{ lib, pkgs, ... }:
let username = "tye";
in {
  home = {
    # Add user packages here
    packages = with pkgs; [
      # Signing in could be nice, ya know?
      gh
      vesktop
    ];

    username = "tye";
    homeDirectory = "/home/tye";

    stateVersion = "24.05";

    # File funkies
    file = {
      "hello.txt" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          echo "Hello again world!"
          echo "SO many lines of text here XDDDDDDDDDDDDDDDD"
        '';
      };
    };

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
  };
}
