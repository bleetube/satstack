{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "steam"
      "steam-original"
      "steam-run"
    ];
  # https://nixos.wiki/wiki/Nvidia
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {

      # Modesetting is needed for most Wayland compositors
      #modesetting.enable = true;

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = false;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "incineroar";
    networkmanager.enable = false;
    interfaces = {
      enp0s31f6.ipv4.addresses = [{
        address = "192.168.1.36";
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
    groups ={
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
        extraGroups = [ "wheel" ];
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

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

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
      # gnome
      #gnomeExtensions.appindicator
    ];

    shellInit = ''
      export EDITOR=vim
      export VISUAL=vim
      pheonix() {
          systemctl restart "$1"
          journalctl -fu "$1"
      }
    '';

    plasma5.excludePackages = with pkgs.libsForQt5; [
      #elisa # music player
      #gwenview # image viewer
      #okular # document viewer
      #oxygen # widgets
      #khelpcenter
      #konsole
      plasma-browser-integration
      #print-manager
    ];
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
    steam.enable = true;
    chromium = {
      enable = true;
      extraOpts = {
        "SpellcheckEnabled" = false;
      };
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
          "text-generation-webui" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4431; ssl = true; }];
            locations."/" = {
              proxyPass = "http://127.0.0.1:7860";
              proxyWebsockets = true;
            };
          });
        };
    };
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"]; # nvidia-smi
      displayManager = {
        sddm.enable = true;
        #defaultSession = "plasmawayland";
      };
      desktopManager.plasma5.enable = true;
    };
  };

  system.stateVersion = "23.05";
}
