{ lib, pkgs, ... }:
let username = "tye";
in {

  home = {
    packages = with pkgs; [
      # Signing in could be nice, ya know?
      gh
      vesktop

      # Nerd fonts time
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

      # File sync
      syncthing
      syncthingtray # Gui for syncthing
    ];

    inherit username;
    homeDirectory = "/home/${username}";

    # Don't change this without reading the wiki!
    # & yes to future me, i did write this. :p
    stateVersion = "24.05";
  };

  fonts = { fontconfig.enable = true; };

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
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command =
            "${pkgs.nixfmt}/bin/nixfmt"; # Path to installed nix formatter
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command =
            "${pkgs.rustfmt}/bin/rustfmt"; # Path to installed rust formatter
        }
      ];
    };

    eza.enable = true;

    # Shell config.
    fish = {
      enable = true;
      shellAbbrs = { ls = "eza"; };
      interactiveShellInit = ''
        if set -q ZELLIJ
        else
          zellij
        end
      '';
    };

    zellij = { enable = true; };
  };
}
