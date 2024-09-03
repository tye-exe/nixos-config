{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    git
    gh # Used for authentication
  ];

  programs = {
    git = {
      enable = true;
      userName = "tye-exe";
      userEmail = "tye@mailbox.org";

      extraConfig = {
        # Removes annoying message about git ignore files.
        advice.addIgnoredFile = false;

        push.autoSetupRemote = true;
        pull.rebase = false;
        init.defaultBranch = "master";

        credential = {
          helper = lib.mkDefault
            "${pkgs.git-credential-manager}/bin/git-credential-manager";
          # Only works if a DE available
          credentialStore = lib.mkDefault "secretservice";
        };
      };
    };
  };
}
