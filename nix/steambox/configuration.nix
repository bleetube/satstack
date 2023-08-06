{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "steam"
        "steam-original"
        "steam-run"
      ];
  };
  hardware = {
    nvidia.modesetting.enable = true;
    opengl = { # https://nixos.wiki/wiki/Nvidia
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  users = {
    users = {
      root = {
        openssh.authorizedKeys.keyFiles = [
          /etc/nixos/ssh/authorized_keys
        ];
      };
      steam = {
        isNormalUser = true;
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      psmisc
      rsync
    ];
  };
  programs = {
    gamescope.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager = {
      gdm.enable = true;
    };
  };
  networking = {
    hostName = "steambox";
    networkmanager.enable = true;
  };
  services.openssh.enable = true;
  system.stateVersion = "23.05";
}
