{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    # zip
    # unzip
    _7zz # Seven zip

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];
}
