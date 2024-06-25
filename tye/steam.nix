{ lib, pkgs, ... }: {
  # home = { packages = pkgs: builtins.elem (lib.getName pkgs) [ "steam" ]; };
  home.packages = with pkgs; [ steam ];
  # allowUnfree = true;
}
