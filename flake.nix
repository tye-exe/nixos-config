{
  description = "My flake(?)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

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

    # nix-ld.url = "github:Mic92/nix-ld";
    # nix-ld.inputs.nixpkgs.follows = "nixpkgs";
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

      # nix-ld = inputs.nix-ld;
    in {
      # System confs
      nixosConfigurations = {
        tye-laptop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./system/configuration.nix
            ./hardware-confs/laptop.nix
            # nix-ld.nixosModules.nix-ld
            # { programs.nix-ld.dev.enable = true; }
          ];
        };

        tye-desktop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./system/configuration.nix
            ./hardware-confs/desktop.nix
            # nix-ld.nixosModules.nix-ld
            # { programs.nix-ld.dev.enable = true; }
          ];
        };
      };

      # Home manager confs
      homeConfigurations = {
        tye-laptop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std inputs; };
          modules = [ ./home/laptop.nix ];
        };

        tye-desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std inputs; };
          modules = [ ./home/desktop.nix ];
        };
      };
    };
}
