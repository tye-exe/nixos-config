{
  description = "My flake(?)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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
        tye = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./tye/home.nix ];
        };
      };
    };
}
