{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ./preset/de.nix
  ];

  programs.rio.settings.fonts.size = 14;

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp

    # DAW
    lmms

    # Synths
    vital
    helm

    mcpelauncher-ui-qt
  ];

  services.syncthing.enable = true;
  tye-services.enabled.syncthingtray = true;
  tye-services.enabled.keyboard = true;
}
