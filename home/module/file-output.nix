{ config, lib, ... }:
with lib;
let
  fout = config.fout;
in
{
  options.fout = {
    # Util
    enable = mkEnableOption "Write a string to a file!";
    filePath = mkOption {
      type = types.str;
      example = "/path/to/file";
      description = "The path to the file.";
    };
    # Options
    content = mkOption {
      type = types.str;
      example = "Hello world!";
      default = "Hello world!";
      description = "The text to be written to the file.";
    };
  };

  config.home.file."fout" = mkIf fout.enable {
    target = fout.filePath;
    text = fout.content;
  };
}
