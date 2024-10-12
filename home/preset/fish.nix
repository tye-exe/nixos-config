{ config, pkgs, ... }:
let
  nixDir = config.nixDir;
  luaScript = "${nixDir}/core.lua";
in
{
  home.packages = with pkgs; [
    fish # Bash 2.0
  ];

  programs = {
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
        shell = {
          expansion = "nix shell nixpkgs#%";
          setCursor = true;
        };

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
        gl = "git log";

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
  };
}
