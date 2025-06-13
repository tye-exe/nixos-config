{
  pkgs,
  config,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    ouch # Decompression & recompression
    sshfs # Mount file system from ssh connection

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];

  # Runs nix gc on entries older than 30 days.
  nix.gc = {
    automatic = true;
    dates = "00:00";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  # Optimizes the nix store on write operations.
  nix.settings.auto-optimise-store = true;
}
