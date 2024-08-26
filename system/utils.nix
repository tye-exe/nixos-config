{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    _7zz # Seven zip

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];

  system.autoUpgrade = let
    nixDir = config.nixDir;
    # Reads in the which flake direvation to use.
    variant = builtins.readFile (/. + "${nixDir}/.identity");
    # Gets the root config for the direvation.
    # As the root file is the same name with the prefix removed.
    conf-file = builtins.replaceStrings [ "tye-" ] [ "" ] variant;
  in {
    enable = true;
    operation = "switch";
    flake = "${nixDir}/#${variant}";
    flags = [
      "-I"
      "nixos-config=${nixDir}/${conf-file}"
      "--update-input"
      "nixpkgs"
      "--impure"
      "-L" # print build logs
    ];
    # Timing doesn't matter due to persistence
    dates = "16:22";
    persistent = true;
  };

}
