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
    ../optional/preset/de.nix
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

    ferdium
  ];

  services = {
    syncthing.enable = true;

    easyeffects = {
      enable = true;
      extraPresets = builtins.readFile ./../optional/preset/easyeffects.json |> builtins.fromJSON;
      preset = "default";
    };

    # Ru begged me to, urgh
    flatpak.packages = [
      "org.vinegarhq.Sober"
    ];
  };

  tye-services.enabled = {
    syncthingtray = true;
  };

  programs.rio.settings.fonts.size = 14;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
