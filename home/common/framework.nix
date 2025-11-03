{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ../optional/preset/de.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  programs.rio.settings.fonts.size = 14;

  home.packages = with pkgs; [
    # Video editing
    shotcut
    gimp

    # DAW
    lmms

    # Synths
    vital
    helm

    mcpelauncher-ui-qt
  ];

  services.syncthing.enable = true;
  tye-services.enabled.syncthingtray = true;
  tye-services.enabled.keyboard = true;

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.joseexposito.touche"
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
