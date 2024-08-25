{
  description = "My flake(?)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # ~/ files config
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Environment config
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-std.url = "github:chessai/nix-std";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-std
    , plasma-manager, ... }:
    let
      # Default nix stuff.
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

      # External lib that's useful
      std = nix-std.lib;

      # nix-ld = inputs.nix-ld;
    in {
      # System confs
      nixosConfigurations = {
        undefined = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system/core.nix ./hardware-confs/undefined.nix ];
        };

        tye-laptop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system/laptop.nix ./hardware-confs/laptop.nix ];
        };

        tye-desktop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system/desktop.nix ./hardware-confs/desktop.nix ];
        };
      };

      # Home manager confs
      homeConfigurations = {
        undefined = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std inputs pkgs-unstable; };
          modules = [
            ./home/core.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };

        tye-laptop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std inputs pkgs-unstable; };
          modules = [
            ./home/laptop.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };

        tye-desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std inputs pkgs-unstable; };
          modules = [
            ./home/desktop.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      };
    };
}
