{ inputs, pkgs, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix
    ./preset/steam.nix

    # Desktop Environment conf
    ./preset/plasma.nix
  ];

  home.packages = with pkgs;
    [
      # Minceraft
      modrinth-app
    ];
}
