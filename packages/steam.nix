{ config, lib, pkgs, ... }:

{
  # Steam requires unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];

  # Comprehensive Steam gaming configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    # Enhanced Steam package with additional libraries
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        # Common missing libraries for games
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        libthai
        xorg.libXmu
        fmodex
      ];
    };

    # Proton compatibility layers
    extraCompatPackages = with pkgs; [
      proton-ge-bin  # GE-Proton for better game compatibility
    ];

    # Protontricks for Wine prefix management
    protontricks.enable = true;

    # Gamescope session for Steam Deck-like experience
    gamescopeSession = {
      enable = true;
      args = [
        "--adaptive-sync"
        "--hdr-enabled"
        "--rt"
        "-W 1920"
        "-H 1080"
      ];
    };
  };

  # Gaming-specific packages
  environment.systemPackages = with pkgs; [
    steam-run        # For non-Steam games requiring FHS
    mangohud         # Performance overlay
    gamescope        # Steam Deck compositor
    gamemode         # Performance optimization daemon
    protonup-qt      # Proton management GUI
  ];

  # GameMode daemon
  programs.gamemode.enable = true;
}
