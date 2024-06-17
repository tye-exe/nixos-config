{ lib, pkgs, ... }:
{
  home = {
    # Add user packages here
    packages = with pkgs; [
      vesktop
    ];

    username = "tye";
    homeDirectory = "/home/tye";

    stateVersion = "24.05";
  };
}
