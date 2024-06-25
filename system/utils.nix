{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # These are like useful utils, yk?
    zip
    unzip
  ];
}
