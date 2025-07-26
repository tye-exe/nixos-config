{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  tye-services = config.tye-services;
in
{
  options.tye-services = {
    enabled = {
      syncthingtray = mkEnableOption "Syncthing tray on login.";
    };
  };

  config.systemd.user =
    let
      syncthing = tye-services.enabled.syncthingtray;
      any = syncthing;
    in
    {
      services = {
        syncthingtray-start = mkIf syncthing {
          Unit.Description = "Starts syncthingtray.";
          Install.WantedBy = [ "default.target" ];

          Service = {
            ExecStart = "${pkgs.writeShellScript "syncthingtray-start" ''
              #!${pkgs.bash}/bin/bash
              ${pkgs.syncthingtray}/bin/syncthingtray --wait''}";
            Restart = "on-failure";
          };
        };
      };
      # Only enable these if any of the services are enabled.
      enable = mkIf any true;
      startServices = mkIf any "sd-switch";
    };
}
