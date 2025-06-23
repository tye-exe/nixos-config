{
  pkgs,
  pkgs-unstable,
  name,
  ...
}:
let
  spell = "typos";
in
{
  home.packages =
    with pkgs;
    [
      # Spellchecker
      typos-lsp
      typos

      nixd # Nix LSP
      nixfmt-rfc-style # Nix fmt
      rustfmt # Rust fmt
      taplo # Toml
      lua-language-server # Lua
      markdown-oxide # Markdown

      # Python decides to be complicated but oh well
      python312Packages.jedi # LSP dependency
      python312Packages.python-lsp-server
      yapf # Fmt
      python312Packages.pyflakes

      superhtml # Additional html lsp

      # javascript
      # typescript
      nodePackages.typescript-language-server
    ]
    ++ (with pkgs-unstable; [
      # Rust.
      # moved to unstable due to bugs within the stable version.
      rust-analyzer
      # markdown
      # html
      # json
      # eslint
      # css
      # moved to unstable due to https://github.com/NixOS/nixpkgs/issues/348596 patch.
      vscode-langservers-extracted

      # Unstable as current stable version is outdated.
      nil # Nix LSP - better code actions
    ]);

  programs.helix = {
    enable = true;

    # Generic configs
    settings = {
      # Generic settings
      editor = {
        line-number = "absolute";
        mouse = false;
        auto-save = true;
        completion-timeout = 100;
        completion-trigger-len = 1;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        # Minimum severity to show a diagnostic after the end of a line:
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          # Minimum severity to show a diagnostic on the primary cursor's line.
          cursor-line = "error";
          # Minimum severity to show a diagnostic on other lines:
          other-lines = "error";
        };
      };

      # Custom keybinds
      keys =
        let
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
        in
        {
          normal = {
            inherit X;
          };
          select = {
            inherit X;
          };
        };

    };
    languages.language-server = {
      # Spell checker
      typos = {
        command = "typos-lsp";
        config.diagnosticSeverity = "Warning";
      };

      rust-analyzer = {
        # Analyses inactive code
        config.cargo.features = "all";
      };

      nixd = {
        nixpkgs.expr = "import <nixpkgs> {}";
        options = {
          nixos.expr = ''(builtins.getFlake "github:tye-exe/nixos-config").nixosConfigurations.${name}.options'';
          home_manager.expr = ''(builtins.getFlake "github:tye-exe/nixos-config").homeConfigurations.${name}.options'';
        };
      };

      superhtml-lsp = {
        command = "superhtml";
        args = [ "lsp" ];
      };
    };

    # language configs
    languages.language = [
      {
        # Gives me the power to have pretty nix files. ^-^
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt"; # Path to installed nix formatter
        language-servers = [
          "nixd"
          "nil"
          spell
        ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command = "${pkgs.rustfmt}/bin/rustfmt --edition 2021"; # Path to installed rust formatter
        language-servers = [
          "rust-analyzer"
          spell
        ];
      }
      {
        name = "toml";
        auto-format = true;
        # formatter.command = "${pkgs.taplo}/bin/taplo fmt";
        language-servers = [
          "taplo"
          spell
        ];
      }
      {
        name = "python";
        auto-format = true;
        formatter.command = "${pkgs.yapf}/bin/yapf";
        language-servers = [
          "pylsp"
          spell
        ];
      }
      {
        name = "lua";
        auto-format = true;
        language-servers = [
          "lua-language-server"
          spell
        ];
      }
      {
        name = "markdown";
        auto-format = true;
        language-servers = [
          "markdown-oxide"
          spell
        ];
      }
      {
        name = "html";
        auto-format = true;
        formatter = {
          command = "${pkgs.superhtml}/bin/superhtml";
          args = [
            "fmt"
            "--stdin"
          ];
        };
        file-types = [ "html" ];
        language-servers = [
          "superhtml-lsp"
          "vscode-html-language-server"
          spell
        ];
      }
    ];
  };
}
