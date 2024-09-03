{ inputs, pkgs, ... }: {

  imports = [ ./core.nix ];

  rio = { fonts.size = 16; };

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp
  ];
}
