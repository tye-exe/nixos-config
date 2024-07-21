{ inputs, pkgs, pkgs-unstable, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix
    ./preset/steam.nix

    # Desktop Environment conf
    ./preset/plasma.nix
  ];

  home.packages = [
    # Minceraft
    pkgs.modrinth-app
    pkgs-unstable.ytmdesktop
  ];
}
