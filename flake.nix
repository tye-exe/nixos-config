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

    # My system manager.
    system-manager.url = "github:tye-exe/system-manager";

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
      system-manager,
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

      # Generates the nixos system configuration for each system
      nix_conf =
        {
          name ? "undefined",
        }:
        {
          inherit system;
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./system/${name}.nix
            ./hardware-confs/${name}.nix
            custom_option
          ];

        };

      # Generates the home-manager configuration for each system
      home_conf =
        {
          name ? "undefined",
        }:
        {
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
            ./home/${name}.nix
            custom_option
          ];
        };
    in
    {
      # System confs
      nixosConfigurations = {
        undefined = lib.nixosSystem (nix_conf);

        laptop = lib.nixosSystem (nix_conf {
          name = "laptop";
        });

        desktop = lib.nixosSystem (nix_conf {
          name = "desktop";
        });

        nas = lib.nixosSystem (nix_conf {
          name = "nas";
        });

      };

      # Home manager confs
      homeConfigurations = {
        undefined = home-manager.lib.homeManagerConfiguration (home_conf);

        laptop = home-manager.lib.homeManagerConfiguration (home_conf {
          name = "laptop";
        });

        desktop = home-manager.lib.homeManagerConfiguration (home_conf {
          name = "desktop";
        });

        nas = home-manager.lib.homeManagerConfiguration (home_conf {
          name = "nas";
        });
      };
    };
}
