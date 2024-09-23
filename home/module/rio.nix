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
    "Block"
    "_"
    "|"
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
    cursor = mkOption {
      type = cursorType;
      example = "Block";
      default = "Block";
      description = "How your cursor will appear in rio.";
    };

    line-height = mkOption {
      type = types.float;
      example = "1.0";
      default = 1.0;
      description = "This option will apply an modifier to line-height.";
    };

    editor = mkOption {
      type = types.str;
      example = "code";
      default = "vi";
      description = "Whenever the key binding OpenConfigEditor is triggered it will use the value of the editor along with the rio configuration path.";
    };

    blinking-cursor = mkOption {
      type = types.bool;
      example = "true";
      default = false;
      description = "Whether the cursor should blink";
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
      cursor = if rio.cursor == "Block" then "▇" else rio.cursor;

      content = std.serde.toTOML {
        cursor = cursor;
        line-height = rio.line-height;
        editor = rio.editor;
        blinking-cursor = rio.blinking-cursor;
        hide-cursor-when-typing = rio.hide-cursor-when-typing;

        fonts.size = rio.fonts.size;
      };
    in
    mkIf rio.enable {
      target = "${rio.configDir}/rio/config.toml";
      text = content;
    };

}
