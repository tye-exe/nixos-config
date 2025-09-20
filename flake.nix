{
  description = "My NixOS configuration :P";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ~/ files config
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    system-manager = {
      url = "github:tye-exe/system-manager/v1.6.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret Management.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-std,
      ...
    }:
    let
      lib = nixpkgs.lib;
      std = nix-std.lib;

      # Allows me to pass custom options into every module.
      opts = {
        keys = import ./lib/keys.nix;
      };

      # Generates the nixos system configuration for each system
      nix_conf =
        {
          name ? "undefined",
          system ? "x86_64-linux",
        }:
        {
          inherit system;
          specialArgs = {
            inherit
              inputs
              system
              name
              opts
              ;
          };
          modules = [
            ./system/${name}.nix
            ./hardware-confs/${name}.nix
            # Allows for making system images with less compressed iso.
            self.nixosModules.myFormats
          ];

        };

      # Generates the home-manager configuration for each system
      home_conf =
        {
          name ? "undefined",
          system ? "x86_64-linux",

        }:
        {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          extraSpecialArgs =
            let
              # Unstable pkgs
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };
            in
            {
              inherit
                std
                inputs
                pkgs-unstable
                system
                name
                opts
                ;
            };
          modules = [
            ./home/${name}.nix
          ];
        };
    in
    {
      # System confs
      nixosConfigurations = (
        [
          "undefined"
          "laptop"
          "framework"
          "desktop"
          "nas"
          {
            name = "rpi";
            system = "aarch64-linux";
          }
        ]
        |> map (settings: (if (builtins.isAttrs settings) then settings else { name = settings; }))
        |> map (settings: {
          name = settings.name;
          value = (nix_conf settings |> lib.nixosSystem);
        })
        |> builtins.listToAttrs
      );

      # Home manager confs
      homeConfigurations =
        [
          "undefined"
          "laptop"
          "framework"
          "desktop"
          "nas"
          {
            name = "rpi";
            system = "aarch64-linux";
          }
        ]
        |> map (settings: (if (builtins.isAttrs settings) then settings else { name = settings; }))
        |> map (settings: {
          name = settings.name;
          value = (home_conf settings |> home-manager.lib.homeManagerConfiguration);
        })
        |> builtins.listToAttrs;

      # Defines custom formats for https://github.com/nix-community/nixos-generators
      # To build use "nix build .#nixosConfigurations.<identity>.config.formats.iso"
      nixosModules.myFormats =
        { config, ... }:
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          # Imports all formats so iso can be overridden (i think).
          imports = [
            inputs.nixos-generators.nixosModules.all-formats
          ];

          formatConfigs.iso =
            { config, modulesPath, ... }:
            {
              imports =
                let
                  # Shows the path to configurable options
                  # module = builtins.trace "${toString modulesPath}/installer/cd-dvd/iso-image.nix";
                in
                [
                  "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
                ];

              # EFI booting
              isoImage.makeEfiBootable = true;

              # USB booting
              isoImage.makeUsbBootable = true;

              formatAttr = "isoImage";
              fileExtension = ".iso";

              # Minor compression helps alot and takes little time.
              # The difference between the default 19 and 3 is about 1GB and 10 minuets of compression time
              # for the former
              isoImage.squashfsCompression = "zstd -Xcompression-level 3";
            };
        };
    };
}
