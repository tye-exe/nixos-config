{ pkgs, ... }:
{
  imports = [ ./fish/fish.nix ];

  home.packages = with pkgs; [
    zellij # Funky terminal multiplexer
    eza # ls replacement
    # Fonts needed for eza
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    zoxide # cd replacement
    fzf # Fuzzy searching
    trashy # Allows easy trashing & restoration of files
    btop # Like "top", but better :p
    gtrash # Allows easier trashing & restoration of files
    yazi # Terminal file manager

    bat # cat replacement
    bat-extras.batman # man upgrade
  ];

  programs = {
    eza = {
      enable = true;
      git = true; # Displays files git status when using -l
      icons = "auto"; # Shows cute icons next to file name.
      enableFishIntegration = false; # This stops alaises being added; I prefer abbrs.
    };

    zellij = {
      enable = true;
      settings = {
        on_force_close = "quit";
        show_startup_tips = false;
        keybinds = {
          unbind = [
            "Alt Left"
            "Alt Right"
            "Alt Up"
            "Alt Down"
            "Ctrl q"
          ];
          locked = {
            unbind = [ "Ctrl g" ];
            "bind \"Ctrl u\"" = {
              SwitchToMode = "Normal";
            };
          };
        };
      };
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
