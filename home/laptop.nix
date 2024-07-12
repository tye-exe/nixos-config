{ inputs, pkgs, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix
    ./preset/rust.nix

    # Desktop Environment conf
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./preset/plasma.nix
  ];
}
