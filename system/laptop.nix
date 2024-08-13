# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [ ./core.nix ];

  networking.hostName = "tye_laptop"; # Define your hostname.

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3333 ];
  networking.firewall.allowedUDPPorts = [ 1900 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
