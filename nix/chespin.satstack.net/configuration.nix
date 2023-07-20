{ config, pkgs, lib, ... }: {
  imports = [
    <nix-bitcoin/modules/presets/secure-node.nix>
    # <nix-bitcoin/modules/presets/hardened.nix>
    # <nix-bitcoin/modules/presets/hardened-extended.nix>
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chespin";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
#   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  users.users.blee = {
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

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      /etc/nixos/ssh/authorized_keys
    ];
  };

  environment.systemPackages = with pkgs; [
    doas
    file
    htop
    nettools
    psmisc
    rsync
    tcpdump
    tree
    vim
    nginx
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

# networking.firewall.enable = false; # enabled by nixbitcoin already
# networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    config.services.bitcoind.rpc.port
    config.services.electrs.port
  ];
  networking.firewall.allowedTCPPortRanges = [{ from = 4400; to = 4499; }];
# networking.firewall.allowedUDPPorts = [ ];
# networking.firewall.allowedUDPPortRanges = [ ];

  security.doas.enable = true;
  security.sudo.enable = false;

  services = {

    openssh.enable = true;

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
  #     recommendedBrotliSettings = true;
        sslProtocols = "TLSv1.3";
        sslDhparam = "/var/acme/dhparams.pem";
        virtualHosts =  
        let
          tlsConfig = {
                onlySSL = true;
                serverName = "chespin.satstack.net";
                sslCertificate = "/var/acme/certificates/chespin.satstack.net.crt";
                sslCertificateKey = "/var/acme/certificates/chespin.satstack.net.key";
            };
        in
        {
          "node_exporter" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4430; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:8030"; };
          });
          "miniflux" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4431; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:8031"; };
          });
          "electrs_exporter" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4432; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:4224"; };
          });
          "vaultwarden" =  (tlsConfig // {
            listen = [{ addr = "0.0.0.0"; port = 4435; ssl = true; }];
            locations."/" = { proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}"; };
          });
        };
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_14; # 15 didn't work for miniflux
    };
    miniflux = {
      enable = true;
      adminCredentialsFile = "/etc/miniflux.env";
      config = {
        LISTEN_ADDR = "127.0.0.1:8031";
        BASE_URL = "https://chespin.satstack.net:4431/";
        METRICS_COLLECTOR = "1";
      };
    };
    postfix = {
      enable = true;
      domain = "satstack.net";
      hostname = "chespin.satstack.net";
      config = {
        myhostname = "chespin.satstack.net";
        smtp_tls_security_level = "encrypt";
        smtpd_tls_security_level = "may";
        smtp_tls_CApath = "/etc/ssl/certs";
      };
    };
    vaultwarden = {
      enable = true;
      backupDir = "/var/lib/vaultwarden/backups";
      #environmentFile = "/var/lib/vaultwarden.env";
      config = {
        DOMAIN = "https://chespin.satstack.net:4435";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8035;
        ROCKET_LOG = "critical";
        # https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_SSL = false;
        SMTP_FROM = "vaultwarden@satstack.net";
        SMTP_FROM_NAME = "satstack.net Bitwarden server";
      };
    };

    bitcoind = {
      disablewallet = true;
      tor.enforce = false; # permit lan connections
      rpc = {
        address = "0.0.0.0";
        #port = 8332;
        #threads = 6;
        allowip = [ 
          "192.168.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
        ];
        users = { # HMAC files are configured in nix-bitcoin.secrets further down
          dojo.passwordHMACFromFile = true;
          mempool.passwordHMACFromFile = true;
          lightningd.passwordHMACFromFile = true;
        };
      };
  #   dbCache = 1024; # defined in presets/secure-node.nix, so cannot be changed here
      txindex = true;
      zmqpubrawblock = "tcp://0.0.0.0:28332";
      zmqpubrawtx = "tcp://0.0.0.0:28333";
      extraConfig = ''
        maxmempool=1024
        zmqpubhashblock=tcp://0.0.0.0:28334 # dojo
        maxorphantx=110
      '';
    };

    electrs = {
      enable = true;
      address = "0.0.0.0";
      tor.enforce = false; # permit lan connections
    };

    ### CLIGHTNING
    clightning = {
      enable = true;
      plugins.prometheus.enable = true;
    };

    # == REST server
    # Set this to create a clightning REST onion service.
    # This also adds binary `lndconnect-clightning` to the system environment.
    # This binary creates QR codes or URLs for connecting applications to clightning
    # via the REST onion service.
    # You can also connect via WireGuard instead of Tor.
    # See ../docs/services.md for details.
    #
    clightning-rest = {
      enable = true;
      lndconnect = {
        enable = true;
        onion = false;
      };
    };

    ### JOINMARKET
    # Set this to enable the JoinMarket service, including its command-line scripts.
    # These scripts have prefix 'jm-', like 'jm-tumbler'.
    # Note: JoinMarket has full access to bitcoind, including its wallet functionality.
    # joinmarket.enable = true;
    #
    # Set this to enable the JoinMarket Yield Generator Bot. You will be able to
    # earn sats by providing CoinJoin liquidity. This makes it impossible to use other
    # scripts that access your wallet.
    # joinmarket.yieldgenerator.enable = true;
    #
    # Set this to enable the JoinMarket order book watcher.
    # joinmarket-ob-watcher.enable = true;

    ### Backups
    # Set this to enable nix-bitcoin's own backup service. By default, it
    # uses duplicity to incrementally back up all important files in /var/lib to
    # /var/lib/localBackups once a day.
    backups.enable = true;
    #
    # You can pull the localBackups folder with
    # `scp -r bitcoin-node:/var/lib/localBackups /my-backup-path/`
    # Alternatively, you can also set a remote target url, for example
    # services.backups.destination = "sftp://user@host[:port]/[relative|/absolute]_path";
    # Supply the sftp password by appending the FTP_PASSWORD environment variable
    # to secrets/backup-encryption-env like so
    # `echo "FTP_PASSWORD=<password>" >> secrets/backup-encryption-env`
    # You many also need to set a ssh host and publickey with
    # programs.ssh.knownHosts."host" = {
    #   hostNames = [ "host" ];
    #   publicKey = "<ssh public from `ssh-keyscan`>";
    # };
    # If you also want to backup bulk data like the Bitcoin & Liquid blockchains
    # and electrs data directory, enable
    # backups.with-bulk-data = true;

  }; # end services

  nix-bitcoin = {
    # announce onions
    onionServices.bitcoind.public = true;
    onionServices.clightning.public = true;

    secrets = {
      bitcoin-rpcpassword-lightningd.user = config.services.bitcoind.user;
      bitcoin-HMAC-lightningd.user = config.services.bitcoind.user;
      bitcoin-rpcpassword-mempool.user = config.services.bitcoind.user;
      bitcoin-HMAC-mempool.user = config.services.bitcoind.user;
      bitcoin-rpcpassword-dojo.user = config.services.bitcoind.user;
      bitcoin-HMAC-dojo.user = config.services.bitcoind.user;
    };

    ### netns-isolation (EXPERIMENTAL)
    # Enable this module to use Network Namespace Isolation. This feature places
    # every service in its own network namespace and only allows truly necessary
    # connections between network namespaces, making sure services are isolated on
    # a network-level as much as possible.
    # nix-bitcoin.netns-isolation.enable = true;

    # The nix-bitcoin release version that your config is compatible with.
    # When upgrading to a backwards-incompatible release, nix-bitcoin will display an
    # an error and provide instructions for migrating your config to the new release.
    configVersion = "0.0.85";
  };

  system.stateVersion = "23.05";
}
