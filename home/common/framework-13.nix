{ inputs, pkgs, ... }:
{

  imports = [
    ./core.nix
    ../optional/preset/de.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.syncthing.enable = true;
  tye-services.enabled.syncthingtray = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
