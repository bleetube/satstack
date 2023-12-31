{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    # "slack"
      "parsec-bin"
      "vscode"
    # "zoom-us"
    # "steam"
    # "steam-original"
    # "steam-run"
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    system76.enableAll = true;
    pulseaudio.enable = true;
  };

  networking = {
    hostName = "weavile";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedTCPPortRanges = [{
        from = 4430;
        to = 4439;
      }];
    };
    wireguard.interfaces = let
      secrets = import ./secrets.nix;
    in {
      wg0 = {
        ips = [ "10.20.21.20/24" ];
        privateKeyFile = "/etc/wireguard-keys/private";
        peers = [{
            publicKey = "${secrets.wireguardServerPubkey}";
            endpoint = "${secrets.wireguardServerIP}:25420";
            allowedIPs = [
              "192.168.0.42/31"  # squirtle/wartortle
            # "192.168.1.36/32"  # incineroar
            # "192.168.1.219/32" # chespin
            ];
        }];
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
#   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  users = {
    groups = {
      acme = {};
    };
    users = {

      root = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
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
          android-tools
          curl
          dnsutils
          git
          jq
          netcat
          tmux
          wget
        ];
      };

      weavile = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          android-tools
          chromium
          firefox
          element-desktop
          jellyfin-media-player
          logseq
          parsec-bin # doesn't start, no error
        # slack # sso auth broken
          synergy
          vscode
        # zoom-us

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
      screen
      tcpdump
      tree
      vim
      # GPU tools
      inxi
      glxinfo
      pciutils # lspci
      # gnome
      #gnomeExtensions.appindicator
      wireguard-tools
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

    # vscode on Wayland
    #sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs = {
  # hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };

    bash.shellAliases = {
      ll = "ls -lAF --classify --group-directories-first";
      l  = "ls -lF --classify --group-directories-first";
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    kdeconnect.enable = true;
    chromium = {
      enable = true;
      extraOpts = {
        "SpellcheckEnabled" = false;
      };
    };
  };

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "blee" ];
          noPass = true;
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
        };
    };
    xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        #defaultSession = "plasmawayland";
      };
      desktopManager.plasma5.enable = true;
    };
  };

  system.stateVersion = "23.05";
}
