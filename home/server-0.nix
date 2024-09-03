{ inputs, pkgs, pkgs-unstable, ... }: {
  imports = [ ./core.nix ];

  programs = {
    plasma.enable = false;
    #  Imma just settle for the cache as anything is a nightmare or doesn't work.
    git.extraConfig = {
      credential = {
        credentialStore = "cache";
        helper = "";
      };
    };
  };
}
