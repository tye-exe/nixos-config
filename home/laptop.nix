{ inputs, pkgs, ... }: {

  imports = [
    ./core.nix

    ./preset/helix.nix
    ./preset/java.nix

    ./module/rio.nix

    # Desktop Environment conf
    # inputs.plasma-manager.homeManagerModules.plasma-manager
    ./preset/plasma.nix
  ];

  rio = { fonts.size = 16; };

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp
  ];
}
