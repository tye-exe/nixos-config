{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Shared configs are in this file.
    ./core.nix
    ./nas/zfs.nix
    ./nas/email.nix
    ./nas/ups.nix
    ./nas/atuin.nix
  ];

  networking = {
    hostName = "tye-nas";
    nameservers = [
      "1.1.1.1" # Cloudflair
      "8.8.8.8" # Google
    ];
    firewall = {
      # Note to self: "docker.internal.host" is blocked by firewall
      enable = true;
      allowedTCPPorts = [
        # SSH
        22
        # Tunnel
        2332
        # Syncthing
        22000
        8384

        # Home assistant
        8123
      ];
      allowedUDPPorts = [
        # Syncthing
        22000
        21027
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      AllowUsers = [ config.users.users.tye.name ];
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # Enable systemd user units at boot
  users.users.tye.linger = true;

  # No gui
  programs = {
    firefox.enable = false;
  };

  # Network routing for containers.
  # environment.systemPackages = with pkgs; [ iptables ];
  # systemd.services."reroute_ports" = {
  #   script = ''
  #     ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3080;
  #     ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 3443;
  #   '';
  #   wantedBy = [ "multi-user.target" ];
  #   description = "Rerouts traffic from port 80 to port 3080; Rerouts traffic from port 443 to port 3443.";
  # };

  ## Run obsidian scripts ##

  # Diary card
  systemd.user.timers."Update_Diary_Card" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "1..2:10:00";
      Unit = "Update_Diary_Card.service";
      Persistent = true;
    };
  };

  systemd.user.services."Update_Diary_Card" = {
    script = ''
      set -eu
      cd /home/tye/zfs/docker/syncthing/data/Me
      ${pkgs.bash}/bin/bash diary_card.sh
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Rambles
  systemd.user.timers."Update_Rambles" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "1..2:10:00";
      Unit = "Update_Rambles.service";
      Persistent = true;
    };
  };

  systemd.user.services."Update_Rambles" = {
    script = ''
      set -eu
      cd /home/tye/zfs/docker/syncthing/data/Me
      ${pkgs.bash}/bin/bash rambles.sh
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Docker #

  # Updates certs for mail server.
  systemd.services."Update_Certs" = {
    # Some months are longer than 30 days.
    # Certs will be updated if they have less than 30 days to live.
    startAt = "*-*-01,20 00:00:00";
    script =
      let
        dir = "/zfs/data/docker/mail_server";
      in
      ''
        ${pkgs.docker}/bin/docker run --rm -t \
        -v "${dir}/docker-data/certbot/certs/:/etc/letsencrypt/" \
        -v "${dir}/docker-data/certbot/logs/:/var/log/letsencrypt/" \
        --net="proxy-network" --name="certbot" \
        certbot/certbot renew
      '';
  };
}
