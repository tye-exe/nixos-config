{
  pkgs,
  config,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    _7zz # Seven zip
    sshfs # Mount file system from ssh connection.

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];

  # Updates the system daily.
  # system.autoUpgrade =
  #   let
  #     nixDir = config.nixDir;
  #     # Reads in the which flake direvation to use.
  #     variant = builtins.readFile (/. + "${nixDir}/.identity");
  #     # Gets the root config for the direvation.
  #     # As the root file is the same name with the prefix removed.
  #     conf-file = builtins.replaceStrings [ "tye-" ] [ "" ] variant;
  #   in
  #   {
  #     enable = true;
  #     operation = "switch";
  #     flake = inputs.self.outPath;
  #     flags = [
  #       "-I"
  #       "nixos-config=${nixDir}/${conf-file}"
  #       "--update-input"
  #       "nixpkgs"
  #       "--impure"
  #       "-L" # print build logs
  #     ];
  #     # Timing doesn't matter due to persistence
  #     dates = "00:00";
  #     persistent = true;
  #   };

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
