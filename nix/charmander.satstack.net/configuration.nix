{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "charmander";
    interfaces = {
      enp0s31f6.ipv4.addresses = [{
        address = "192.168.1.39";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp0s31f6";
    };
    # TODO https://nixos.wiki/wiki/Encrypted_DNS
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
#   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  users = {
    groups.acme = {};
    users = {
      blee = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          curl
          dnsutils
          git
          jq
          netcat
          tmux
          wget
        ];
      };
      timburr = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_timburr_keys
        ];
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
      acme = {
        isSystemUser = true;
        createHome = true;
        home = "/var/acme";
        shell = "/usr/sbin/nologin";
        group = "acme";
      };
      nginx = {
        extraGroups = [ "acme" ];
      };
      root = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
      };
    };
  };

  # permit read access to certificates for the users in the acme group, such as nginx
  systemd.tmpfiles.rules = [
    "d /var/acme 0750 acme acme - -"
    "d /var/acme/certificates 0750 acme acme - -"
  ];

  environment = {
    systemPackages = with pkgs; [
      doas
      file
      htop
      libressl
      nettools
      psmisc
      rsync
      tcpdump
      tree
      vim
      #nginx
    ];
    shellInit = ''
      export EDITOR=vim
      export VISUAL=vim
      pheonix() {
          systemctl restart "$1"
          journalctl -fu "$1"
      }
    '';
  };

  programs = {
    bash.shellAliases = {
      ll = "ls -lAF --classify --group-directories-first";
      l  = "ls -lF --group-directories-first";
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  networking.firewall.enable = false;
# networking.firewall.allowPing = true;
# networking.firewall.allowedTCPPorts = [
#   22
#   80
#   443
#   config.services.bitcoind.rpc.port
#   config.services.electrs.port
# ];
# networking.firewall.allowedTCPPortRanges = [
#   { from = 4400; to = 4499; }
#   { from = 28332; to = 28334; }
# ];
# networking.firewall.allowedUDPPorts = [ ];
# networking.firewall.allowedUDPPortRanges = [ ];

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "blee" ];
          noPass = true;
        }
        { # remotely reboot this PC remotely via Termius on Android
          users = [ "timburr" ];
          noPass = true;
          cmd = "reboot";
        }
      ];
    };
    dhparams.enable = true; # seems to not work, had to generate one manually
  };

  services = {

    openssh.enable = true;
    journald.extraConfig = "MaxRetentionSec=30day";

    # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/monitoring/prometheus/exporters.nix
    prometheus.exporters.node = {
      enable = true;
      port = 8030;
      enabledCollectors = [
        "cpu.info"
        "interrupts"
        "netstat"
        "vmstat"
        "systemd"
        "tcpstat"
        "processes"
      ];
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/web-servers/nginx/default.nix
    nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        sslProtocols = "TLSv1.3";
#       sslDhparam = config.security.dhparams.path;
        sslDhparam = "/etc/ssl/dhparams.pem";
        virtualHosts =  
        let
          domainName = "charmander.satstack.net";
          tlsConfig = {
                onlySSL = true;
                serverName = domainName;
                sslCertificate = "/var/acme/certificates/${domainName}.crt";
                sslCertificateKey = "/var/acme/certificates/${domainName}.key";
            };
        in
        {
          "node_exporter" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4430; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:8030"; };
          });
          "sd-webui" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4431; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:7861"; };
          });
        };
    };

  };

  system.stateVersion = "23.05";
}
