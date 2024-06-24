{ pkgs, ... }: {

  programs.plasma = {
    enable = true;

    hotkeys.commands."launch-konsole" = {
      name = "Launch Rio";
      key = "Meta+Alt+K";
      command = "rio";
    };
  };
}
