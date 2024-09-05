{ pkgs, inputs, ... }: {
  # Shared configs are in this file.
  imports = [ ./core.nix ];

  networking = {
    hostName = "tye-server-0";
    nameservers = [ "1.1.1.1" "8.8.8.8" ]; # Cloudflair, Google
    defaultGateway = "192.168.0.1";
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.0.33";
      prefixLength = 24;
    }];
    firewall.enable = false;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  users.users."tye".extraGroups = [ "docker" ];

  programs = { firefox.enable = false; };
}
