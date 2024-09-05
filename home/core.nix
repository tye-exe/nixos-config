{ pkgs, config, inputs, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
in {

  imports = [
    ./preset/helix.nix
    ./preset/plasma.nix
    ./preset/git.nix
    ./preset/fish.nix
    ./preset/cli.nix

    ./module/file-output.nix
  ];

  home = {
    packages = with pkgs; [
      # dotool # Can simulate various user inputs.
      ncdu # Disk usage analyzer
      viu # Terminal image viewer
    ];

    inherit username homeDirectory;
  };

  fonts = { fontconfig.enable = true; };

  programs = {
    # Allows for seamless integration with nix flake environments.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index.enable = true;
  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = "24.05";
}
