{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    _7zz # Seven zip

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];

  system.autoUpgrade = let
    nixDir = "/home/tye/nixos";
    # Reads in the which flake direvation to use.
    variant = builtins.readFile /home/tye/nixos/.identity;
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
    dates = "00:00";
    persistent = true;
  };

}
