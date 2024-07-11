{ pkgs, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  configDir = "${homeDirectory}/.config";
  nixDir = "${homeDirectory}/nixos";
in {

  imports = [ ./preset/helix.nix ./module/rio.nix ];

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

      bat # Cat replacement
      eza # Ls replacement
      trashy # Allows easy trashing & restoration of files

      libreoffice-qt6-still # Office but without the Microsoft
      hunspell # Spellchecker for libre office
      hunspellDicts.en_GB-ise # Use the GB lib for the spell checker

      # Allows screensharing
      xwaylandvideobridge
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

      # Sets the default pager to bat
      shellInit = ''
        set PAGER bat
      '';
    };

    zellij = {
      enable = true;
      settings = {
        on_force_close = "quit";
        keybinds = { unbind = [ "Alt Left" "Alt Right" "Alt Up" "Alt Down" ]; };
      };
    };

    rio.enable = true;
  };

  # IT WORKS. I LOVE YOU https://scvalex.net/posts/63/ <3
  home.sessionVariables = let
    libPath = with pkgs;
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
      ];
  in { LD_LIBRARY_PATH = libPath; };

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
