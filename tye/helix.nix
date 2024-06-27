{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Spellchecker
    typos-lsp
    typos
  ];

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

    # Spell checker
    languages.language-server = { typos.command = "typos-lsp"; };

    # language configs
    languages.language = [
      {
        # Gives me the power to have pretty nix files. ^-^
        name = "nix";
        auto-format = true;
        formatter.command =
          "${pkgs.nixfmt}/bin/nixfmt"; # Path to installed nix formatter
        language-servers = [ "nil" "typos" ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command =
          "${pkgs.rustfmt}/bin/rustfmt"; # Path to installed rust formatter
        language-servers = [ "rust-analyzer" "typos" ];
      }
    ];
  };
}
