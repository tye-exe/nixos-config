{ pkgs, inputs, ... }: {
  # Shared configs are in this file.
  imports = [ ./core.nix ];

  networking.hostName = "tye-server-0"; # Define your hostname.

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  users.users."tye".extraGroups = [ "docker" ];

  programs = { firefox.enable = false; };
}
