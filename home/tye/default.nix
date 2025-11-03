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

    ssh = {
      enable = true;
      extraConfig = ''
        # Check to see if local address is accessible
        Match host nas exec "nc -w 1 -z 192.168.0.33 16777"
          HostName 192.168.0.33
        Match host nas
          HostName tye-home.xyz
        Host nas
          Port 16777
          User tye

        Host tyevps
          HostName tyevps.vps.webdock.cloud
          Port 16788
          User tael

        Host fyvps
          HostName kass.vps.webdock.cloud
          Port 16799
          User tsey
      '';
    };
  };
}
