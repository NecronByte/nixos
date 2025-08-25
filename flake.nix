{
  description = "ThinkPad T480 - NixOS + Hyprland + Catppuccin Mocha (Laptop-optimized)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.t480 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.default
          {
            # Hook Home Manager to system
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.oskar = import ./home.nix;
          }
        ];
      };
    };
}