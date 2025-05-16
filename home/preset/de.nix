{ pkgs, lib, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  configDir = "${homeDirectory}/.config";
in
{

  imports = [
    ./../module/rio.nix
    ./../preset/plasma.nix
  ];

  home.packages = with pkgs; [
    # Libre office
    libreoffice-qt6-still # Office but without the Microsoft
    hunspell # Spellchecker for libre office
    hunspellDicts.en_GB-ise # Use the GB lib for the spell checker

    # Communication
    whatsapp-for-linux
    vesktop # Alternate discord client.
    telegram-desktop # Do i need to explain?
    thunderbird # Email

    rio # Terminal emulator
    syncthingtray # Gui for syncthing
    xwaylandvideobridge # Allows screensharing
    vlc # Plays videos :P
    kdePackages.merkuro # Calander.
    obsidian # Note taking using markdown.
    pdfmixtool # Used to edit PDF's
    et # Simple terminal timer
    rnote # Note taking application
    qimgv # Image viewer
  ];

  programs = {
    rio.enable = true;
    qutebrowser.enable = true;
  };

  rio = {
    enable = true;
    inherit configDir;
    editor.program = "hx";
    hide-cursor-when-typing = true;

    cursor = {
      blinking = true;
    };
  };
}
