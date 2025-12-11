{
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [
    ../optional/preset/helix.nix
    ../optional/preset/git.nix
    ../optional/preset/cli.nix
    ../optional/preset/rust.nix

    ../optional/module/systemd.nix
  ];

  home = {
    packages =
      with pkgs;
      [
        ncdu # Disk usage analyzer
        viu # Terminal image viewer
        ripgrep # Faster alternative to grep
        caligula # Every time i need this i have to spend 5 minuets searching for it
      ]
      ++ (with inputs.nix-alien.packages.${system}; [
        nix-alien
      ]);
  };

  fonts = {
    fontconfig.enable = true;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.warn_timeout = "1m";
    };

    nix-index.enable = true;

    git.settings.user = {
      name = "tye-travcomuk";
      email = "tye@travcomuk.com";
    };
  };
}
