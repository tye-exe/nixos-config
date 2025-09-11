{
  pkgs,
  lib,
  name,
  ...
}:
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
        l = "eza -la";
        ls = "eza";
        la = "eza -a";
        ll = "eza -lh";
        lla = "eza -lha";

        cat = "bat";
        man = "batman";
        ts = "gtrash put";
        du = "ncdu"; # I always keep forgetting this
        image = "qimgv";
        sm = "system-manager";
        wine = "WINEPREFIX=./.wine; wine"; # Sets wine to use CWD as windows path
        "--help" = {
          expansion = "--help | bat -plhelp";
          position = "anywhere";
        };

        shell = {
          expansion = "nix shell nixpkgs#% --set-env-var nix_shell_status \"nix_shell\" --command sh -c \"fish\"";
          setCursor = true;
        };
        shell-unstable = {
          expansion = "nix shell nixpkgs/nixos-unstable#% --set-env-var nix_shell_status \"nix_shell\" --command sh -c \"fish\"";
          setCursor = true;
        };
        unfree-shell = {
          expansion = "NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#% --impure --set-env-var nix_shell_status \"nix_shell\" --command sh -c \"fish\"";
          setCursor = true;
        };
        unfree-shell-unstable = {
          expansion = "NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs/nixos-unstable#% --impure --set-env-var nix_shell_status \"nix_shell\" --command sh -c \"fish\"";
          setCursor = true;
        };

        # "which" often resolves to a symlink
        where = {
          expansion = "which % | eza -l --stdin";
          setCursor = true;
        };

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

        roblox = lib.mkIf (name == "desktop") "org.vinegarhq.Sober >> /dev/null";
      };

      functions = {
        # Sets up template shell environment, alongside nix-direnv
        mkenv = ''
          [ ! -e .envrc ] && echo "use flake" >> .envrc
          direnv allow
        '';

        # Creates a default flake file.
        mkflake = ''
          [ ! -e flake.nix ] && cp --no-preserve all ${./flake_template.nix} flake.nix && hx flake.nix:23:13;
        '';

        # Modifies the fish prompt to show if inside a nix_shell
        fish_prompt = builtins.readFile ./fish_prompt.fish;
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
