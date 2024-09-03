{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    gh # Used for authentication
    libsecret # Stores auth details
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

        # Idk how this exactly works but it allows me to login so i'm happy
        credential.helper = "libsecret";
      };
    };
  };

}
