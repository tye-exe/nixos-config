{ inputs, pkgs, pkgs-unstable, ... }: {

  imports = [ ./core.nix ./preset/de.nix ];

  home.packages = [
    pkgs.syncthing # File sync

    # Minceraft
    pkgs.modrinth-app
    # Java for Mc
    # pkgs.jdk8
    pkgs.jdk17_headless
    # pkgs.openjdk21_headless

    pkgs-unstable.ytmdesktop
  ];

  # Start noisetorch on DE startup with my main mic as the input.
  programs.plasma.startup.startupScript."start_noisetorch".text = ''
    noisetorch -i -s "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback"
  '';

}
