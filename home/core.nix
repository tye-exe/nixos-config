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
    ./preset/git.nix
    ./preset/cli.nix
    ./preset/rust.nix

    ./module/systemd.nix
  ];

  home = {
    packages =
      with pkgs;
      [
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
      config.warn_timeout = "1m";
    };

    nix-index.enable = true;

    ssh = {
      enable = true;
      extraConfig = ''
        # Check to see if local address is accessible
        Match host nas exec "nc -w 1 -z 192.168.0.33 %p"
          HostName 192.168.0.33
        Match host nas
          HostName tye-home.xyz
        Host nas
          Port 16777
          User tye
      '';
    };
  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = lib.mkDefault "24.05";
}
