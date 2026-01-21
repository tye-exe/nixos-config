{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ../optional/preset/de.nix
  ];

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
}
