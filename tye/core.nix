{ pkgs, std, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  confDir = "${homeDirectory}/.config";
  nixDir = "${homeDirectory}/nixos";
in {
  home = {
    packages = with pkgs; [
      # Signing in could be nice, ya know?
      gh

      # Alternate discord client.
      vesktop

      # Nerd fonts time
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

      # File sync
      syncthing
      syncthingtray # Gui for syncthing

      bat # Cat replacment
      eza # Ls replacment
      trashy # Allows easy trashing & restoration of files
    ];

    inherit username homeDirectory;
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
        pull.rebase = "false";

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
        la = "eza -a";
        ll = "eza -lh";
        lla = "eza -lha";
        cat = "bat";
        ts = "trash";

        # Git abbrs
        gs = "git status";
        gd = "git diff";
        gc = {
          expansion = ''git commit -m "%"'';
          setCursor = true;
        };
        gca = "git commit --amend --no-edit";
        ga = "git add";
        gp = "git push";

        # I got tired of having to type it in :P
        cdn = "cd ${nixDir}";
      };

      # Runs either make command & then returns back to previous dir.
      functions = {
        hm-switch = ''
          set -f PAST_DIR (pwd)
          cd ${nixDir}
          make hm-switch
          cd $PAST_DIR'';
        sys-switch = ''
          set -f PAST_DIR (pwd)
          cd ${nixDir}
          sudo make sys-switch
          cd $PAST_DIR'';
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

    rio = { enable = true; };

  };

  # I couldn't figure out how to get the "TOML" value rio needs for config
  # So i just did it myself \o/
  home.file."rio-conf" = {
    target = "${confDir}/rio/config.toml";
    text = std.serde.toTOML {
      cursor = "▇";
      blinking-cursor = true;
      hide-cursor-when-typing = true;
      # line-height = 1.6;
      editor = "hx";

      fonts.size = 18;
    };
  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = "24.05";
}
