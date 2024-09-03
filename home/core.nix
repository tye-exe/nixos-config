{ pkgs, config, inputs, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  configDir = "${homeDirectory}/.config";
  nixDir = config.nixDir;
  luaScript = "${nixDir}/core.lua";
in {

  imports = [
    ./preset/helix.nix
    ./preset/plasma.nix

    ./module/rio.nix
    ./module/file-output.nix
  ];

  home = {
    packages = with pkgs; [
      # Terminal stuffs
      rio # Terminal emulator
      fish # Bash 2.0
      zellij # Funky terminal multiplexer

      # Nerd fonts time
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

      syncthing # File sync
      syncthingtray # Gui for syncthing

      bat # cat replacement
      eza # ls replacement
      zoxide # cd replacement
      fzf # Fuzzy searching
      trashy # Allows easy trashing & restoration of files

      libreoffice-qt6-still # Office but without the Microsoft
      hunspell # Spellchecker for libre office
      hunspellDicts.en_GB-ise # Use the GB lib for the spell checker

      # Misc
      xwaylandvideobridge # Allows screensharing
      thunderbird # Email
      gh # Signing in could be nice, ya know?
      vesktop # Alternate discord client.
      telegram-desktop # Do i need to explain?
      vlc # Plays videos :P
      dotool # Can simulate various user inputs.
      localsend # Share files over local wifi network.
      sshfs # Mount file system from ssh connection.
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
        pull.rebase = false;
        init.defaultBranch = "master";

        # Idk how this exactly works but it allows me to login so i'm happy
        credential.helper = "libsecret";
      };
    };

    eza = {
      enable = true;
      git = true; # Displays files git status when using -l
      icons = true; # Shows cute icons next to file name.
      enableFishIntegration =
        false; # This stops alaises being added; I prefer abbrs.
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
        "7z" = "7zz"; # Seven zip uses "7zz", not "7z"

        # Git abbrs
        gs = "git status";
        gd = "git diff";
        gc = {
          expansion = ''git commit -m "%"'';
          setCursor = true;
        };
        gca = "git commit --amend --no-edit";
        ga = "git add";
        gaa = "git add .";
        gp = "git push";
        gu = "git pull";

        # Opens the given path/file with the default application.
        open = {
          expansion = "xdg-open % &>> /dev/null";
          setCursor = true;
        };

        # Shortcuts to void command output
        void = {
          expansion = ">> /dev/null";
          position = "anywhere";
        };
        evoid = {
          expansion = "&>> /dev/null";
          position = "anywhere";
        };
      };

      functions = {
        ## Following three are functions as i got error when using Aliases ##
        # Sets the identity of this machine
        set-identity = "${luaScript} identity";
        # Switches home-manager to new config.
        hm-switch = "${luaScript} hm-switch";
        # Switches system to new config.
        sys-switch = "${luaScript} sys-switch";

        # Emulates the pressing of the given keys.
        key = ''
          command -q dotool && echo type $argv | dotool
        '';

        # Sets up template shell environment, alongside nix-direnv
        mk-env = ''
          [ ! -e .envrc ] && echo "use flake" >> .envrc
          direnv allow
        '';
      };

      # Only starts zellij if it's not already open.
      interactiveShellInit = ''
        if set -q ZELLIJ
        else
          zellij
        end
      '';
    };

    # Terminal multiplexer
    zellij = {
      enable = true;
      settings = {
        on_force_close = "quit";
        keybinds = { unbind = [ "Alt Left" "Alt Right" "Alt Up" "Alt Down" ]; };
      };
    };

    rio.enable = true;

    # "cd" replacement
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    # Allows for seamless integration with nix flake environments.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index.enable = true;
  };

  rio = {
    enable = true;
    inherit configDir;
    editor = "hx";
    blinking-cursor = true;
    hide-cursor-when-typing = true;
  };

  # Don't change this without reading the wiki!
  # & yes to future me, i did write this. :p
  home.stateVersion = "24.05";
}
