{ pkgs, std, ... }: {
  home.packages = with pkgs; [
    python3
    black # formatter
    python312Packages.python-lsp-server
    python312Packages.pylsp-rope
  ];

  programs.helix.languages.language = [{
    name = "python";
    language-servers = [ "pylsp" ];
    auto-format = true;
    formatter.command = "${pkgs.black}/bin/black";
  }];

  programs.helix.languages.language-server.pylsp.config.pylsp = {
    plugins.black.enabeled = true;
    plugins.rope_autoimport.enabled = true;
    plugins.pyls_mypy.enabled = true;
    plugins.pyls_mypy.live_mode = true;
  };
}
