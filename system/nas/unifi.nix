{ pkgs, ... }:
{
  services.unifi = {
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb-7_0;
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];
}
