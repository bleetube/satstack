{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  # NVIDIA GP104 [GeForce GTX 1070] 01:00.0
  services.xserver.videoDrivers = ["nvidia"]; # proprietary
  hardware.nvidia.nvidiaPersistenced = true; # keep GPUs awake in headless-mode
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
      ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
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
  users = {
    groups = {
      a1 = {};
      acme = {};
      steam = {};
    };
    users = {

      root = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
      };

      a1 = {
        isSystemUser = true;
        home = "/opt/automatic1111";
        shell = "/run/current-system/sw/bin/bash";
        packages = with pkgs; [
          git
          tmux
        ];
        group = "a1";
      };

      acme = {
        isSystemUser = true;
        createHome = true;
        home = "/var/acme";
        shell = "/run/current-system/sw/bin/nologin";
        group = "acme";
      };

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

      nginx = {
        extraGroups = [ "acme" ];
      };

      steam = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
        isNormalUser = true;
      };

      timburr = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_timburr_keys
        ];
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };
  # permit read access to certificates for the users in the acme group, such as nginx
  systemd.tmpfiles.rules = [
    "d /var/acme 0750 acme acme - -"
    "d /var/acme/certificates 0750 acme acme - -"
  ];
  #services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  environment = {
    systemPackages = with pkgs; [
      doas
      file
      htop
      libressl
      nettools
      nginx # for running nginx -t
      psmisc
      rsync
      tcpdump
      tree
      vim
      # GPU tools
      inxi
      glxinfo
      pciutils # lspci
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
      l  = "ls -lF --classify --group-directories-first";
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  networking.firewall.enable = false;
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "blee" ];
          noPass = true;
        }
        { # troubleshooting
          users = [ "steam" ];
          noPass = true;
          cmd = "dmesg";
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
          domainName = "${config.networking.hostName}.satstack.net";
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
            locations."/" = {
              proxyPass = "http://127.0.0.1:7860";
              proxyWebsockets = true;
            };
          });
        };
    };

  };

  system.stateVersion = "23.05";
}