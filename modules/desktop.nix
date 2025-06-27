{ config, pkgs, ... }:
{
  # Display Manager and Desktop Environment
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha";  # Added theme reference
      };
      defaultSession = "plasma";
    };
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "se";
    };
  };
  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];  # Changed this line
  };
  # Power management
  services.power-profiles-daemon.enable = true;
  # SSH server (optional, secure configuration)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
  };
  # Enable XWayland for compatibility
  programs.xwayland.enable = true;
  # GTK theming
  programs.dconf.enable = true;
  # System fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.enable = true;
}
