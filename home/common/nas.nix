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
    kitty # Used for term compatibility
  ];

  # Link to zfs dataset
  home.file.zfs.source = config.lib.file.mkOutOfStoreSymlink "/zfs/data";

  programs = {
    git.settings = {
      credential = {
        # credentialStore = "gpg";
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
  };
}
