{ inputs, pkgs, pkgs-unstable, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/steam.nix

    # Desktop Environment conf
    ./preset/plasma.nix
  ];

  home.packages = [
    # Minceraft
    pkgs.modrinth-app
    # Java for Mc
    # pkgs.jdk8
    pkgs.jdk17_headless
    # pkgs.openjdk21_headless

    pkgs-unstable.ytmdesktop
  ];
}
