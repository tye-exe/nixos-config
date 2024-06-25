{ pkgs, ... }: {

  home.packages = with pkgs;
    [
      # I love my dot
      cinnamon.mint-cursor-themes
    ];

  programs.plasma = {
    enable = true;

    workspace = {
      # I like my eyes, thank you very much
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

    panels = [{
      location = "top";
      height = 48;
      widgets = [
        # Launcher menu
        "org.kde.plasma.kickoff"
        # Has the open apps on it
        {
          name = "org.kde.plasma.icontasks";
          config = {
            General.launchers = [
              "applications:org.kde.dolphin.desktop"
              "applications:firefox.desktop"
              "applications:rio.desktop"
            ];
          };
        }
        "org.kde.plasma.marginsseparator"
        {
          systemTray.items = {
            # We explicitly show bluetooth and battery
            shown = [
              "org.kde.plasma.clipboard"
              # "org.kde.plasma.volume"
              "org.kde.plasma.volume"
              "org.kde.plasma.bluetooth"
            ];
            # And explicitly hide networkmanagement and volume
            hidden = [
              "org.kde.plasma.networkmanagement"
              # "org.kde.plasma.volume"
            ];
          };
        }
        { digitalClock = { }; }
      ];
    }];
  };
}
