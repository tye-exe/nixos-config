{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ./preset/de/de.nix
  ];

  rio.fonts.size = 16;

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp

    # DAW
    lmms

    # Synths
    vital
    helm
  ];

  services.syncthing.enable = true;
  tye-services.enabled.syncthingtray = true;
}
