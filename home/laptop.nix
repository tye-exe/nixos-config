{ inputs, pkgs, ... }: {

  imports = [ ./core.nix ./preset/de.nix ];

  rio = { fonts.size = 16; };

  home.packages = with pkgs; [
    syncthing

    # Video editing
    shotcut
    gimp
  ];
}
