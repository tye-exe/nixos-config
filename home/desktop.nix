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
    jdk17_headless

    # Minecraft bedrock!
    mcpelauncher-ui-qt

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

  programs.rio.settings.fonts.size = 14;

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
