{ inputs, pkgs, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix
    ./preset/steam.nix

    # Desktop Environment conf
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./preset/plasma.nix
  ];

  home.packages = with pkgs;
    [
      # Minceraft
      modrinth-app
    ];
}
