{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./core.nix ];

  home.packages = with pkgs; [
    rio # Used for term compatibility
  ];

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
