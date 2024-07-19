{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    zip
    unzip

    # Disk management
    gparted
    ntfs3g # Ntfs support
  ];
}
