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

      # Gives more git stuff?
      # package = pkgs.gitFull;

      extraConfig = {
        # Removes annoying message about git ignore files.
        advice.addIgnoredFile = false;

        push.autoSetupRemote = true;
        pull.rebase = false;
        init.defaultBranch = "master";

        credential.helper = lib.mkDefault "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
        # credential.helper = "${pkgs.gnupg}/bin/gpg-agent";
      };
    };
  };
}
