{
  std,
  config,
  lib,
  ...
}:
with lib;
let
  rio = config.rio;
  cursorType = types.enum [
    "block"
    "underline"
    "beam"
  ];
in
{
  options.rio = {
    # Util
    enable = mkEnableOption "Rio - A terminal emulator";
    configDir = mkOption {
      type = types.str;
      example = "/home/<user>/.config";
      description = "The path to your user '.config' location. You must exclude the ending '/' character!";
    };
    # Options
    cursor = {
      shape = mkOption {
        type = cursorType;
        example = "block";
        default = "block";
        description = "The shape of your cursor in rio.";
      };
      blinking = mkOption {
        type = types.bool;
        example = "true";
        default = false;
        description = "Whether the cursor should blink.";
      };
    };

    line-height = mkOption {
      type = types.float;
      example = "1.0";
      default = 1.0;
      description = "This option will apply an modifier to line-height.";
    };

    editor = {
      program = mkOption {
        type = types.str;
        example = "code";
        default = "vi";
        description = "Whenever the key binding OpenConfigEditor is triggered it will use the value of the editor along with the rio configuration path.";
      };
      args = mkOption {
        type = types.listOf types.str;
        example = "[]";
        default = [ ];
        description = "The configuration args for the default editor.";
      };
    };

    hide-cursor-when-typing = mkOption {
      type = types.bool;
      example = "false";
      default = false;
      description = "Whether to hide the cursor when typing";
    };

    # Font options
    fonts = {
      size = mkOption {
        type = types.int;
        example = "18";
        default = 18;
        description = "The size of the font";
      };
    };
  };

  config.home.file."rio" =
    let
      # The word block is easier to type than the symbol.
      content = std.serde.toTOML {
        line-height = rio.line-height;
        hide-cursor-when-typing = rio.hide-cursor-when-typing;

        editor = rio.editor;

        cursor = rio.cursor;

        fonts.size = rio.fonts.size;
      };
    in
    mkIf rio.enable {
      target = "${rio.configDir}/rio/config.toml";
      text = content;
    };

}
