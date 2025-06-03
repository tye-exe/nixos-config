{ pkgs, ... }:
{
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
