{ pkgs, ... }:
let spell = "typos";
in {
  home.packages = with pkgs; [
    # Spellchecker
    typos-lsp
    typos

    nil # Nix
    nixfmt-rfc-style # Nix fmt
    rust-analyzer # Rust
    rustfmt # Rust fmt
    taplo # Toml

    # Python decides to be complicated but oh well
    python312Packages.jedi # LSP dependency
    python312Packages.python-lsp-server
    yapf # Fmt
    python312Packages.pyflakes

    # markdown
    # html
    # json
    # eslint
    # css
    vscode-langservers-extracted
  ];

  programs.helix = {
    enable = true;

    # Generic configs
    settings = {
      # Generic settings
      editor = {
        mouse = false;
        auto-save = true;
        completion-timeout = 100;
        completion-trigger-len = 1;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        # Custom keybinds
        keys = {
          normal = let
            down = "move_visual_line_down";
            up = "move_visual_line_up";
          in {
            # Lets me save files normally (insert cool face).
            C-s = ":w";
            # I can move up or down faster now.
            A-j = "[${down}, ${down}, ${down}]";
            A-k = "[${up}, ${up}, ${up}]";
          };

          view = let
            down = "scroll_down";
            up = "scroll_up";
          in {
            # I can move up or down faster now.
            A-j = "[${down}, ${down}, ${down}]";
            A-k = "[${up}, ${up}, ${up}]";
          };
        };
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
        language-servers = [ "nil" spell ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command =
          "${pkgs.rustfmt}/bin/rustfmt --edition 2021"; # Path to installed rust formatter
        language-servers = [ "rust-analyzer" spell ];
      }
      {
        name = "toml";
        auto-format = true;
        # formatter.command = "${pkgs.taplo}/bin/taplo fmt";
        language-servers = [ "taplo" spell ];
      }
      {
        name = "python";
        auto-format = true;
        formatter.command = "${pkgs.yapf}/bin/yapf";
        language-servers = [ "pylsp" spell ];
      }
    ];
  };
}
