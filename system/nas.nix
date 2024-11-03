{
  pkgs,
  inputs,
  config,
  ...
}:
{
  # Shared configs are in this file.
  imports = [ ./core.nix ];

  networking = {
    hostName = "tye-nas";
    nameservers = [
      "1.1.1.1" # Cloudflair
      "8.8.8.8" # Google
    ];
    defaultGateway = "192.168.0.1";
    # Static IP addr
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

  # Network routing for containers.
  environment.systemPackages = with pkgs; [ iptables ];
  systemd.services."reroute_ports" = {
    script = ''
      ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3080;
      ${pkgs.iptables}/bin/iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 3443;
    '';
    wantedBy = [ "multi-user.target" ];
    description = "Rerouts traffic from port 80 to port 3080; Rerouts traffic from port 443 to port 3443.";
  };

  # Email monitoring
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls = "on";
      auth = "login";
      tls_starttls = false;
    };
    accounts = {
      default = {
        host = "smtp.gmail.com";
        passwordeval = "cat /home/tye/.smtp_password.txt";
        user = "tye.exe@gmail.com";
        from = "tye.exe@gmail.com";
      };
    };
  };

  ## Sets root email to my email.
  environment.etc = {
    "aliases" = {
      text = ''
        root: tye.exe@gmail.com
      '';
      mode = "0644";
    };
  };

  # Cron jobs
  services.cron =
    let
      # Sends email if zpool isn't healthy
      zpoolCheck = pkgs.writeShellScript "zpool-check.sh" ''
        # Exit if drives are healthy
        zpool status -x | grep -v "all pools are healthy" && 

        # Else send output to my mail
        echo -e "Content-Type: text/plain\r\nSubject: Zpool\r\n\r\n$(zpool status -x)" | sendmail tye.exe@gmail.com;
      '';
    in
    {
      enable = true;
      # Check zpool health every hour
      systemCronJobs = [ "0 * * * *  root ${zpoolCheck}" ];
    };

  # ZFS
  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "3d2f5b22";

  # Adds my ZFS pool to nix's knowledge
  boot.zfs.extraPools = [ "zfs" ];

  services.zfs = {
    # Create backup of files.
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";

      # Amounts of each backup to keep:
      frequent = 4; # Every 15 mins
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
    # Reclaim no longer allocated space?
    # https://openzfs.github.io/openzfs-docs/man/master/8/zpool-trim.8.html
    trim = {
      enable = true;
      interval = "weekly";
    };
    # Check drive integrity
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
    # Email alerts
    zed = {
      enableMail = true;
      settings = {
        ZED_EMAIL_ADDR = [ "root" ];
        ZED_NOTIFY_VERBOSE = false;

        ZED_USE_ENCLOSURE_LEDS = true;
      };
    };
  };

  ### Managing zfs imperatively due to lack of available (working) tooling ###
  # Creating pool:
  # zpool create zfs mirror sda sdb
  #
  # Creating dataset:
  # zfs create zfs/data
  #
  # Enabling auto snapshot
  # sudo zfs set com.sun:auto-snapshot=true zfs
}
