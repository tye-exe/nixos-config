{ pkgs, ... }:
let
  username = "tye";
  home = "/home/${username}";
  confDir = "${home}/.config/";
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
    ];

    inherit username;
    homeDirectory = home;

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
      shellAbbrs = {
        ls = "eza";
        gs = "git status";
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
