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
  ];

  home.packages =
    with pkgs;
    [
      # Minceraft
      hmcl
      # Java for Mc
      # pkgs.jdk8
      jdk17_headless
      # pkgs.openjdk21_headless

      obs-studio
      # Games
      heroic
    ]
    ++ (with pkgs-unstable; [ ytmdesktop ]);

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

}
