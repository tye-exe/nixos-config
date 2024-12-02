{
  pkgs,
  inputs,
  pkgs-unstable,
  lib,
  ...
}:
{

  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  home.packages = with pkgs; [
    # I love my dot
    mint-cursor-themes
    # Default editor for kde
    kdePackages.kate
  ];

  programs.plasma = {
    enable = lib.mkDefault true;

    workspace = {
      # I like my eyes, thank you very much
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      theme = "breeze-dark";

      # Dot! :)
      cursor = {
        theme = "GoogleDot-Black";
        size = 24;
      };

      wallpaper = "${pkgs-unstable.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Honeywave/contents/images/5120x2880.jpg";

      clickItemTo = null;
      iconTheme = null;
      soundTheme = null;
      splashScreen = {
        engine = null;
        theme = null;
      };
      tooltipDelay = null;
      wallpaperFillMode = null;
      wallpaperPictureOfTheDay = null;
      wallpaperSlideShow = null;
      windowDecorations = {
        library = null;
        theme = null;
      };
    };

    hotkeys.commands."launch-rio" = {
      name = "Launch Rio";
      key = "Ctrl+Alt+T";
      command = "rio";
    };

    startup.startupScript = {
      syncthingtray.text = "syncthingtray &>> /dev/null &";
      # syncthing.text = "syncthing &>> /dev/null &";
      # script.text = "syncthing &>> /dev/null &; syncthingtray &>> /dev/null &;";
    };

    # startup.startupScript."start_noisetorch" = {
    #   # Start noisetorch on DE startup with my main mic as the input.
    #   text = ''
    #     firefox &>> /dev/null &;
    #     noisetorch -i -s "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback" &>> /dev/null &;
    #   '';
    # };

    panels = [
      {
        location = "top";
        height = 48;
        widgets = [
          # Launcher menu
          { name = "org.kde.plasma.kickoff"; }
          # Has the open apps on it
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:rio.desktop"
              ];
            };
          }

          { name = "org.kde.plasma.marginsseparator"; }

          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.clipboard"
                "org.kde.plasma.volume"
                "org.kde.plasma.bluetooth"
              ];
              hidden = [ "org.kde.plasma.networkmanagement" ];
            };
          }
          { digitalClock = { }; }
        ];
      }
    ];
  };
}
