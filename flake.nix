{
  description = "Modular NixOS configuration flake";

  inputs = {
    # Use nixos-unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };

    # Development shell for system maintenance
    devShells.x86_64-linux.default =
      import ./shell.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
  };
}
