{
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{

  imports = [
    ./core.nix
    ./preset/de.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.packages = with pkgs; [
    # Minceraft
    prismlauncher
    # Java for Mc
    # pkgs.jdk8
    jdk17_headless
    # pkgs.openjdk21_headless

    obs-studio
    # Games
    heroic
    mangohud
  ];

  services.syncthing.enable = true;

  tye-services.enabled = {
    syncthingtray = true;
    noisetorch = true;
  };

  rio.fonts.size = 14;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Ru begged me to, urgh
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];
}
