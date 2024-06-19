{ pkgs, ... }:
let username = "tye";
in {
  home = {
    packages = with pkgs; [ clang mold rustup ];

    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";
  };

  programs = {
    clang.enable = true;
    mold.enable = true;
    rustup.enable = true;
  };
}
