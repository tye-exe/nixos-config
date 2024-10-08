{
  pkgs-unstable,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./debug.nix
  ];

  programs.nixvim = {
    package = pkgs-unstable.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    enableMan = true;

    plugins = {
      rustaceanvim.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };
    };

    keymaps = [
      # Util
      {
        key = "U";
        mode = "n";
        action = "<C-r>";
        options.desc = "Redo";
      }
      {
        key = "<C-q>";
        mode = "n";
        action = "";
        options.desc = "***Doesn't*** quit";
      }
      {
        mode = "n";
        key = "<S-down>";
        action = "ddp";
        options.desc = "Move line down";
      }
      {
        mode = "n";
        key = "<S-up>";
        action = "ddkP";
        options.desc = "Move line up";
      }
      {
        mode = "n";
        key = "gs";
        action = "_";
        options.desc = "Goto first non-whitespace char in line";
      }
      {
        mode = "n";
        key = "gl";
        action = "$";
        options.desc = "Goto last char in line";
      }

      # LSP
      {
        key = " a";
        mode = "n";
        action.__raw = "vim.lsp.buf.code_action";
        options.silent = true;
        options.unique = true;
      }
      # {
      #   key = " gd";
      #   mode = "n";
      #   action = "<cmd>Telescope lsp_definitions\r";
      #   options.unique = true;
      #   options.silent = true;
      # }
      {
        key = " k";
        mode = "n";
        action = "<cmd>Telescope";
      }

      # Opening & closing pairs
      {
        key = "{";
        mode = "i";
        action = "{}<esc>i";
      }
      {
        key = "(";
        mode = "i";
        action = "()<esc>i";
      }
      {
        key = "[";
        mode = "i";
        action = "[]<esc>i";
      }
      {
        key = "\"";
        mode = "i";
        action = "\"\"<esc>i";
      }
      {
        key = "'";
        mode = "i";
        action = "''<esc>i";
      }
    ];
  };
}
