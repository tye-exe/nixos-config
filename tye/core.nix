{ pkgs, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  confDir = "${homeDirectory}/.config/";
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

      bat # Cat replacment
      eza # Ls replacment
    ];

    inherit username homeDirectory;

    file."config.kdl" = {
      target = "${confDir}zellij/";
      text = ''on_force_close "quit"'';
    };
  };

  fonts = { fontconfig.enable = true; };

  programs = {
    git = {
      enable = true;
      userName = "tye-exe";
      userEmail = "tye@mailbox.org";

      # Gives more git stuff?
      package = pkgs.gitFull;

      extraConfig = {
        # Removes annoying message about git ignore files.
        advice.addIgnoredFile = false;
        push.autoSetupRemote = true;

        # Idk how this exactly works but it allows me to login so i'm happy
        credential.helper = "libsecret";
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

    eza = {
      enable = true;
      git = true; # Displays files git status when using -l
      icons = true; # Shows cute icons next to file name.
    };

    # Shell config.
    fish = {
      enable = true;
      shellAbbrs = {
        # Util abbrs.
        ls = "eza";
        cat = "bat";

        # Git abbrs
        gs = "git status";
        gd = "git diff";
        gc = ''git commit -m ""'';
        gca = "git commit --amend --no-edit";
        ga = "git add ";
        gp = "git push";
      };
      # Only starts zellij if it's not already open.
      interactiveShellInit = ''
        if set -q ZELLIJ
        else
          zellij
        end
      '';
    };

    zellij = {
      enable = true;
      settings = { on_force_close = "quit"; };
    };

    rio = {
      enable = true;
      # settings = std.serde.toTOML { on_force_close = "quit"; };
    };

  };
  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = "24.05";
}
