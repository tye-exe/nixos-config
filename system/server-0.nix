{ pkgs, inputs, ... }: {
  # Shared configs are in this file.
  imports = [ ./core.nix ];

  networking.hostName = "tye-server-0"; # Define your hostname.

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs = { firefox.enable = false; };
}
