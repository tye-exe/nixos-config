{ inputs, pkgs, pkgs-unstable, ... }: {
  imports = [ ./core.nix ];

  programs.plasma.enable = false;
}
