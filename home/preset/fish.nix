{ pkgs, ... }:
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
        ts = "gtrash put";
        "7z" = "7zz"; # Seven zip uses "7zz", not "7z"
        shell = {
          expansion = "nix shell nixpkgs#% --command sh -c \"fish\"";
          setCursor = true;
        };
        shell-unstable = {
          expansion = "nix shell nixpkgs/nixos-unstable#% --command sh -c \"fish\"";
          setCursor = true;
        };
        du = "ncdu"; # I always keep forgetting this
        image = "qimgv";
        sm = "system-manager";

        # Pipes rg into delta (pager).
        rgi = {
          expansion = "rg --json -C 3 % | delta";
          setCursor = true;
        };

        # Git abbrs #
        gd = "git diff";
        gdc = "git diff --cached";

        gc = "git commit";
        gcm = {
          expansion = ''git commit -m "%"'';
          setCursor = true;
        };
        gca = "git commit --amend --no-edit";

        ga = "git add";
        gaa = "git add .";
        gai = "git add -i";
        gap = "git add --patch";

        gs = "git status --short --b";
        gss = "git status --show-stash -b";

        gp = "git push";
        gu = "git pull";
        gl = ''git log --all --graph --pretty=format:"%C(magenta)%h:%n%C(brightcyan)%an  %ar%C(blue)  %D%n%C(cyan)%s%n"'';
        gll = ''git log --all --graph --pretty=format:"%C(magenta)%h:%n%C(brightcyan)%an  %ar%C(blue)  %D%n%C(cyan)%s%n%+b"'';

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

        # Abbr for my shell timer.
        timer = {
          expansion = "et % &>> /dev/null &";
          setCursor = true;
        };
      };

      functions = {
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
