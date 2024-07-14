{ pkgs, ... }:
let spell = "typos";
in {
  home.packages = with pkgs; [
    # Spellchecker
    typos-lsp
    typos

    nil # Nix
    nixfmt-rfc-style # Nix fmt
    # rust-analyzer # Rust
    # rustfmt # Rust fmt
    taplo # Toml

    # Python decides to be complicated but oh well
    python312Packages.jedi # LSP dependency
    python312Packages.python-lsp-server
    yapf # Fmt
    python312Packages.pyflakes
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
        language-servers = [ "nil" spell ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command =
          "${pkgs.rustfmt}/bin/rustfmt"; # Path to installed rust formatter
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
