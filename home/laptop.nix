{ inputs, pkgs, ... }: {

  imports = [ ./core.nix ./preset/de.nix ];

  rio.fonts.size = 16;

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp
  ];

  services.syncthing.enable = true;
  tye-services.enabled.syncthingtray = true;
}
