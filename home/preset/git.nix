{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    git
    gh # Used for authentication
    delta
  ];

  programs = {
    git = {
      enable = true;
      userName = "tye-exe";
      userEmail = "tye@mailbox.org";
      lfs.enable = true;

      # direnv files
      ignores = [
        ".envrc"
        ".direnv"
      ];

      extraConfig = {
        # Removes annoying message about git ignore files.
        advice.addIgnoredFile = false;

        push.autoSetupRemote = true;
        pull.rebase = false;

        rebase.missingCommitCheck = "warn";
        merge.conflicstyhle = "zdiff3";

        interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
        diff = {
          renames = "copies";
          interHunkContext = 10;
        };
        init.defaultBranch = "main";

        signing = {
          key = "null";
          signedByDefault = true;
        };

        core = {
          editor = "${pkgs.helix}/bin/hx";
          compression = 9;
          preloadIndex = true;
          pager = "delta";
        };

        credential = {
          helper = lib.mkDefault "${pkgs.git-credential-manager}/bin/git-credential-manager";
          # Only works if a DE available
          credentialStore = lib.mkDefault "secretservice";
        };

        delta = {
          navigate = true;
          dark = true;
          line-numbers = true;
          hypderlinks = true;
        };
      };
    };
  };
}
