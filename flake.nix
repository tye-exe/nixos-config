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

  outputs = inputs@{ self, nixpkgs, home-manager, nix-std, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      std = nix-std.lib;
    in {
      # System confs
      nixosConfigurations = {
        tye = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ];
        };
      };

      # Home manager confs
      homeConfigurations = {
        # home-manager.users.tye = import ./tye/home.nix { inherit pkgs std; };
        tye = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit std; };
          modules = [
            # Base home-manager conf
            ./tye/home.nix
            # Desktop Enviroment conf
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      };
    };
}
