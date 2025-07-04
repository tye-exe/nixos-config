{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ./preset/de.nix
  ];

  programs.rio.settings.fonts.size = 12;

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
