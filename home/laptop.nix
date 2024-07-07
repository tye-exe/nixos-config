{ inputs, ... }: {

  imports = [
    ./core.nix

    ./preset/rust.nix

    # Desktop Environment conf
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./preset/plasma.nix
  ];
}
