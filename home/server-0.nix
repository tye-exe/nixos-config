{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./core.nix ];

  programs = {
    plasma.enable = false;
    git.extraConfig = {
      credential = {
        credentialStore = "gpg";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
}
