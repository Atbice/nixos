{ config, pkgs, inputs, ... }:

{
  imports = [
    # Hardware configuration (auto-generated)
    ./hardware-configuration.nix

    # Boot configuration
    ./boot.nix

    # System modules
    ./modules/hardware.nix
    ./modules/desktop.nix
    #./modules/development.nix# Fixed: was services.nix

    # All packages
    ./packages
  ];

  # System information
  system.stateVersion = "25.05";

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Network configuration
  networking = {
    hostName = "nixos";  # TODO: Change to your actual hostname
    networkmanager.enable = true;
  };

  # User configuration
  users.users.bice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
    shell = pkgs.zsh;
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Locale configuration
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "sv_SE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  nix.settings = {
    download-buffer-size = 268435456;  # 256 MB
};
}
