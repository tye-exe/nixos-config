{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    # Generic configs
    settings.editor = {
      mouse = false;
      auto-save = true;
      completion-timeout = 100;
      completion-trigger-len = 1;
      lsp = {
        display-messages = true;
        display-inlay-hints = true;
      };
    };

    # formmater configs
    languages.language = [
      {
        # Gives me the power to have pretty nix files. ^-^
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
}
