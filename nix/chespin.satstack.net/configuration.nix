# See the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
# https://nixos.org/manual/nixos/stable/

{ config, pkgs, ... }:

{
  imports =
    [
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

  networking.firewall.enable = true;
# networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 8333 50001 ];
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
        };
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

  };

  system.stateVersion = "23.05";
}
