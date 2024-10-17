{
  description = "My flake(?)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ~/ files config
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

    # Plugin overlay for nvim
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";

    # Nvim config
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

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
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [ inputs.nixneovimplugins.overlays.default ];
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # External lib that's useful
      std = nix-std.lib;

      # Allows me to pass the nixDir arg into every module recersively.
      custom_option = (
        { lib, ... }:
        {
          options.nixDir = lib.mkOption {
            type = lib.types.str;
            default = builtins.readFile "/tmp/tye_nix_config/path";
          };
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

        tye-laptop = lib.nixosSystem {
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

        tye-desktop = lib.nixosSystem {
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

        tye-server-0 = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/server-0.nix
            ./hardware-confs/server-0.nix
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

        tye-laptop = home-manager.lib.homeManagerConfiguration {
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

        tye-desktop = home-manager.lib.homeManagerConfiguration {
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

        tye-server-0 = home-manager.lib.homeManagerConfiguration {
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
            ./home/server-0.nix
            custom_option
          ];
        };
      };
    };
}
