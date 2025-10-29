{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./avatar.nix ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  # Wayland?
  services.displayManager.sddm.wayland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # This is enabled when flatpaks are.
  environment.plasma6.excludePackages = [ pkgs.kdePackages.discover ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    socketActivation = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Scanner
  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.utsushi
      pkgs.hplipWithPlugin
    ];
  };
  services.udev.packages = [ pkgs.utsushi ];
  environment.defaultPackages = [ pkgs.simple-scan ];
  users.groups.lp.members = [ config.users.users.tye.name ];
}
