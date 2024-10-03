{
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{

  imports = [
    ./core.nix
    ./preset/de.nix
  ];

  home.packages = [
    # Minceraft
    pkgs.modrinth-app
    # Java for Mc
    # pkgs.jdk8
    pkgs.jdk17_headless
    # pkgs.openjdk21_headless

    pkgs.obs-studio
    pkgs-unstable.ytmdesktop
  ];

  services.syncthing.enable = true;

  tye-services.enabled = {
    syncthingtray = true;
    noisetorch = true;
  };
}
