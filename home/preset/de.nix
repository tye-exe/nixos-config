{ pkgs, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  configDir = "${homeDirectory}/.config";
in {

  imports = [ ./../module/rio.nix ];

  home.packages = with pkgs; [
    # Libre office
    libreoffice-qt6-still # Office but without the Microsoft
    hunspell # Spellchecker for libre office
    hunspellDicts.en_GB-ise # Use the GB lib for the spell checker

    rio # Terminal emulator
    syncthingtray # Gui for syncthing
    xwaylandvideobridge # Allows screensharing
    thunderbird # Email
    vesktop # Alternate discord client.
    telegram-desktop # Do i need to explain?
    vlc # Plays videos :P
    localsend # Share files over local wifi network.
  ];

  programs = { rio.enable = true; };

  rio = {
    enable = true;
    inherit configDir;
    editor = "hx";
    blinking-cursor = true;
    hide-cursor-when-typing = true;
  };
}
