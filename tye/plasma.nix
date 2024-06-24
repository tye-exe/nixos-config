{ pkgs, ... }: {

  home.packages = with pkgs;
    [
      # I love my dot
      cinnamon.mint-cursor-themes
    ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";

      cursor = {
        theme = "GoogleDot-Black";
        size = 24;
      };
    };

    hotkeys.commands."launch-rio" = {
      name = "Launch Rio";
      key = "Ctrl+Alt+T";
      command = "rio";
    };
  };
}
