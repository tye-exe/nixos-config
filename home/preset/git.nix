{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    git
    gh # Used for authentication
    diff-so-fancy
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
        rebase.missingCommitCheck = "warn";

        interactive.diffFilter = "${pkgs.diff-so-fancy}/bin/diff-so-fancy --patch";
        diff = {
          renames = "copies";
          interHunkContext = 10;
        };
        init.defaultBranch = "main";

        core = {
          editor = "${pkgs.helix}/bin/hx";
          compression = 9;
          preloadIndex = true;
        };
        pager.diff = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | $PAGER";

        diff-so-fancy.markEmptyLines = false;

        credential = {
          helper = lib.mkDefault "${pkgs.git-credential-manager}/bin/git-credential-manager";
          # Only works if a DE available
          credentialStore = lib.mkDefault "secretservice";
        };
      };
    };
  };
}
