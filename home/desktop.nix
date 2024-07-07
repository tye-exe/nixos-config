{ inputs, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix
    ./preset/rust.nix
    ./preset/steam.nix

    # Desktop Environment conf
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./preset/plasma.nix
  ];
}
