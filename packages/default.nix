{ pkgs, config, lib, ... }:

{
  # Import complex package configurations
  imports = [
    ./steam.nix
    # ./development.nix  # Uncomment when created
  ];

  # Simple system packages
  environment.systemPackages = import ./simple.nix { inherit pkgs; };
}
