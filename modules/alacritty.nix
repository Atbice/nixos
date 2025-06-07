# modules/terminal.nix
{ config, pkgs, ... }:

{
  # Install Alacritty system-wide
  environment.systemPackages = [ pkgs.alacritty ];

  # Create system-wide Alacritty config
  environment.etc."xdg/alacritty/alacritty.toml".source = ../toml/alacritty.toml;

  # Set as default terminal for KDE if desired
  environment.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
