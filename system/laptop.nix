{ pkgs, inputs, ... }:

{
  imports = [
    ./core.nix
    ./de/de.nix
  ];

  networking.hostName = "tye_laptop"; # Define your hostname.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 3333 ];
  # networking.firewall.allowedUDPPorts = [ 1900 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.bluetooth.enable = true;

  tye.remote-build = {
    enable = true;
  };
}
