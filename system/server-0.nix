{ pkgs, inputs, ... }:
{
  # Shared configs are in this file.
  imports = [ ./core.nix ];

  networking = {
    hostName = "tye-server-0";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ]; # Cloudflair, Google
    defaultGateway = "192.168.0.1";
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.0.33";
        prefixLength = 24;
      }
    ];
    firewall.enable = false;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  users.users."tye".extraGroups = [ "docker" ];

  # No gui
  programs = {
    firefox.enable = false;
  };

  environment.systemPackages = with pkgs; [ iptables ];
  systemd.services."reroute_ports" = {
    script = ''
      ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3080;
      ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 3443;
    '';
    wantedBy = [ "multi-user.target" ];
    description = "Rerouts traffic from port 80 to port 3080; Rerouts traffic from port 443 to port 3443.";
  };
}
