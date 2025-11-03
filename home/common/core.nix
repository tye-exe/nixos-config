{
  pkgs,
  config,
  inputs,
  pkgs-unstable,
  system,
  lib,
  user,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  imports = [
    ../${user}/default.nix
  ];

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
  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = lib.mkDefault "24.05";
}
