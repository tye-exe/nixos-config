{ pkgs, lib, ... }:
let
  username = "tye";
  homeDirectory = "/home/${username}";
  configDir = "${homeDirectory}/.config";
in
{

  imports = [
    ./../preset/plasma.nix
    ./../preset/qutebrowser.nix
  ];

  home.packages = with pkgs; [
    # Libre office
    libreoffice-qt6-still # Office but without the Microsoft
    hunspell # Spellchecker for libre office
    hunspellDicts.en_GB-large # GB dictionary

    # Communication
    beeper # General communication
    vesktop # Alternate discord client.
    thunderbird # Email

    syncthingtray # Gui for syncthing
    kdePackages.xwaylandvideobridge # Allows screensharing
    vlc # Plays videos :P
    kdePackages.merkuro # Calander.
    obsidian # Note taking using markdown.
    pdfmixtool # Used to edit PDF's
    rnote # Note taking application
    qimgv # Image viewer
    wl-clipboard # Access clipboard from terminal
  ];

  programs = {
    rio.enable = true;
    rio.settings = {
      confirm-before-quit = false;
      hide-mouse-cursor-when-typing = true;

      editor.program = "hx";
      cursor.shape = "block";
    };
  };
}
