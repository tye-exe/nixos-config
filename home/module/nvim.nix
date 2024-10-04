{
  std,
  config,
  lib,
  ...
}:
with lib;
let
  nvim = config.nvim;
  nvimDir = "${config.home.homeDirectory}/.config/nvim";
  keybindings =
    with types;
    submodule {
      options = {
        leader = mkOption { type = str; };
        follower = mkOption { type = str; };
        mode = mkOption { type = str; };
        args = mkOption { type = listOf str; };
      };
    };
in
{
  options.nvim = {
    enable = mkEnableOption "nvim configurations!";

    rust = {
      enable = mkEnableOption "enable rustaceanvim";
      keybinds = mkOption { type = types.listOf keybindings; };
    };
  };

  config.home.file =
    let
      rust-lua = "${nvimDir}/after/ftplugin/rust.lua";
    in
    {
      "init.lua" = mkIf nvim.enable {
        target = "${nvimDir}/init.lua";
        text =
          let
            content = [ ];
          in
          #++ optionals nvim.rust.enable [ "require \"${rust-lua}\"" ];
          concatStringsSep "\n" content;
      };
      "rust.lua" = mkIf nvim.rust.enable {
        target = rust-lua;
        text =
          let

            content =
              [ "local bufnr = vim.api.nvim_get_current_buf()" ]
              ++ concatMap (keybind: [
                ''
                  vim.keymap.set(
                    "${keybind.mode}",
                    "${keybind.leader}${keybind.follower}",
                    function()
                      vim.cmd.RustLsp{${concatStringsSep "," (concatMap (arg: [ "'${arg}'" ]) keybind.args)}}
                    end,
                    { silent = true, buffer = bufnr }
                  )''
              ]) nvim.rust.keybinds;
          in
          concatStringsSep "\n" content;
      };
    };

}
