{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # Shared configs are in this file.
  imports = [
    ./core.nix
    ./de/de.nix
    ./virtualization.nix
  ];

  networking.hostName = "tye"; # Define your hostname.

  # Program configs
  programs = {
    # Steam has to be managed in config.nix due to some system-wide settings being modified
    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  # Fixes F (function) keys not working for my keyboard.
  boot = {
    kernelModules = [ "hid-apple" ];
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };

  # It's undergoing mitosis!
  # virtualisation.vmware.host.enable = true;

  services.flatpak.enable = true;
}
