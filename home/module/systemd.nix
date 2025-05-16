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
      noisetorch = mkEnableOption "Noisetorch with desktop mic.";
    };
  };

  config.systemd.user =
    let
      syncthing = tye-services.enabled.syncthingtray;
      noisetorch = tye-services.enabled.noisetorch;
      any = syncthing || noisetorch;
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

        # Start noisetorch on DE startup with my main mic as the input.
        noisetorch-init = mkIf noisetorch {
          Unit = {
            Description = "Start/Loads noisetorch with the desired microphone.";
            StartLimitBurst = 10;
          };
          Install.WantedBy = [ "default.target" ];

          Service = {
            ExecStart = "${pkgs.writeShellScript "noisetorch-init" ''
              #!${pkgs.bash}/bin/bash
              noisetorch -i -s "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback"
            ''}";
            Restart = "on-failure";
            RestartSec = "10s";
          };
        };
      };
      # Only enable these if any of the services are enabled.
      enable = mkIf any true;
      startServices = mkIf any "sd-switch";
    };
}
