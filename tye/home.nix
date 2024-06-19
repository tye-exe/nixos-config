{ lib, pkgs, ... }:
let username = "tye";
in {

  home = {
    packages = with pkgs; [
      # Signing in could be nice, ya know?
      gh
      vesktop
    ];

    inherit username;
    homeDirectory = "/home/${username}";

    # Don't change this without reading the wiki!
    # & yes to future me, i did write this. :p
    stateVersion = "24.05";
  };

  programs = {
    git = {
      enable = true;
      userName = "tye-exe";
      userEmail = "tye@mailbox.org";

      extraConfig = {
        # Removes annoying message about git ignore files.
        advice.addIgnoredFile = false;
        push.autoSetupRemote = true;
      };
    };

    # Gives me the power to have pretty nix files. ^-^
    helix = {
      enable = true;
      languages.language = [{
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }];
    };

    eza.enable = true;

    # Shell config.
    fish = {
      enable = true;
      shellAbbrs = { ls = "eza"; };
    };

    zellij = { enable = true; };
  };
}
