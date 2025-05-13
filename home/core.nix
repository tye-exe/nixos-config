{
  pkgs,
  config,
  inputs,
  pkgs-unstable,
  system,
  lib,
  ...
}:
let
  username = "tye";
  homeDirectory = "/home/${username}";
in
{

  imports = [
    ./preset/helix.nix
    ./preset/plasma.nix
    ./preset/git.nix
    ./preset/fish.nix
    ./preset/cli.nix
    ./preset/rust.nix

    ./module/file-output.nix
    ./module/systemd.nix
  ];

  # Needed for ./module/systemd.nix
  systemd.user = {
    enable = true;
    startServices = "sd-switch";
  };

  home = {
    packages =
      with pkgs;
      [
        # dotool # Can simulate various user inputs.
        ncdu # Disk usage analyzer
        viu # Terminal image viewer
        ripgrep # Faster alternative to grep
      ]
      ++ (with inputs.nix-alien.packages.${system}; [
        nix-alien
      ]);

    inherit username homeDirectory;
  };

  fonts = {
    fontconfig.enable = true;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index.enable = true;

  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = lib.mkDefault "24.05";
}
