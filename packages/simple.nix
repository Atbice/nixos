{ pkgs }:

with pkgs; [
  # Desktop applications
  kdePackages.qtmultimedia
  kdePackages.filelight
  youtube-music
  google-chrome
  alacritty
  kitty
  haruna
  vesktop
  onlyoffice-desktopeditors

  # Creative tools
  blender
  krita
  pinta

  # Development tools
  git
  vscode-fhs
  python312

  # System utilities
  cacert
  icu
  fastfetch
  pwvucontrol

  # Archive tools
  zip
  unzip
  rar

  # Gaming tools
  steam-run
  bottles
  lutris
  protontricks
  winetricks
  wineWowPackages.stable

  # AppImage support
  appimage-run
  gearlever
  fragments

  # SDDM theme
  (catppuccin-sddm.override {
    flavor = "mocha";
    font = "Noto Sans";
    fontSize = "9";
    # TODO: Add wallpaper.png to your config directory
    # background = ./wallpaper.png;
    loginBackground = true;
  })
]
