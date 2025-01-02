{
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  imports = [ ./core.nix ];

  home.packages = with pkgs; [
    rio # Used for term compatibility
  ];

  # Link to zfs dataset
  home.file.zfs.source = config.lib.file.mkOutOfStoreSymlink "/zfs/data";

  programs = {
    plasma.enable = false;
    git.extraConfig = {
      credential = {
        # credentialStore = "gpg";
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };
}
