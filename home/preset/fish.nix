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

        # Git abbrs #
        gd = "git diff";
        gdc = "git diff --cached";

        gc = {
          expansion = ''git commit -m "%"'';
          setCursor = true;
        };
        gca = "git commit --amend --no-edit";

        ga = "git add";
        gaa = "git add .";
        gai = "git add -i";

        gs = "git status";
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
