{
  description = "My flake(?)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

    # ~/ files config
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Enviroment config
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-std.url = "github:chessai/nix-std";
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, nix-std, plasma-manager, ... }:
    let
      # Default nix stuff.
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      # External lib that's useful
      std = nix-std.lib;
    in {
      # System confs
      nixosConfigurations = {
        tye-laptop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system/configuration.nix ./hardware-confs/laptop.nix ];
        };

        tye-desktop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system/configuration.nix ./hardware-confs/desktop.nix ];
        };
      };

      # Home manager confs
      homeConfigurations = {
        tye-laptop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std; };
          modules = [
            # Base home-manager conf
            ./tye/core.nix
            # Rust lang config
            ./tye/rust.nix
            # Desktop Enviroment conf
            inputs.plasma-manager.homeManagerModules.plasma-manager
            ./tye/plasma.nix
          ];
        };

        tye-desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std; };
          modules = [
            # Base home-manager conf
            ./tye/core.nix
            # Rust lang config
            ./tye/rust.nix
            # Desktop Enviroment conf
            inputs.plasma-manager.homeManagerModules.plasma-manager
            ./tye/plasma.nix
            # GAMES
            ./tye/steam.nix
          ];
        };
      };
    };
}
