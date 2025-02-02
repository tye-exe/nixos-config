{
  description = "My NixOS configuration :P";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ~/ files config
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Environment config
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Expands upon the nix std lib.
    nix-std.url = "github:chessai/nix-std";

    # Get deps for non-nix binaries.
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-std,
      plasma-manager,
      nix-alien,
      ...
    }:
    let
      # Default nix stuff.
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      # Current pkgs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # Unstable pkgs
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # External lib that's useful
      std = nix-std.lib;

      # Allows me to pass custom options into every module.
      custom_option = (
        { lib, ... }:
        {
        }
      );
    in
    {
      # System confs
      nixosConfigurations = {
        undefined = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/core.nix
            ./hardware-confs/undefined.nix
            custom_option
          ];
        };

        laptop = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/laptop.nix
            ./hardware-confs/laptop.nix
            custom_option
          ];
        };

        desktop = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/desktop.nix
            ./hardware-confs/desktop.nix
            custom_option
          ];
        };

        nas = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/nas.nix
            ./hardware-confs/nas.nix
            custom_option
          ];
        };

      };

      # Home manager confs
      homeConfigurations = {
        undefined = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              std
              inputs
              pkgs-unstable
              system
              ;
          };
          modules = [
            ./home/undefined.nix
            custom_option
          ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              std
              inputs
              pkgs-unstable
              system
              ;
          };
          modules = [
            ./home/laptop.nix
            custom_option
          ];
        };

        desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              std
              inputs
              pkgs-unstable
              system
              ;
          };
          modules = [
            ./home/desktop.nix
            custom_option
          ];
        };

        nas = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              std
              inputs
              pkgs-unstable
              system
              ;
          };
          modules = [
            ./home/nas.nix
            custom_option
          ];
        };
      };
    };
}
