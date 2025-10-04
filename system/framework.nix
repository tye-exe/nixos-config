{ pkgs, inputs, ... }:

{
  imports = [
    ./core.nix
    ./de/de.nix
  ];

  networking.hostName = "framework"; # Define your hostname.
  hardware.bluetooth.enable = true;

  # On screen keyboards work alot better in X
  services.xserver.enable = true;
  environment.systemPackages = with pkgs; [
    onboard
  ];

}
