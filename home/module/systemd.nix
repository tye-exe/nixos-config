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

  config.systemd.user.services = {
    syncthingtray-start = mkIf tye-services.enabled.syncthingtray {
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
    noisetorch-init = mkIf tye-services.enabled.noisetorch {
      Unit.Description = "Start/Loads noisetorch with the desired microphone.";
      Install.WantedBy = [ "default.target" ];

      Service = {
        ExecStart = "${pkgs.writeShellScript "noisetorch-init" ''
          #!${pkgs.bash}/bin/bash
          noisetorch -i -s "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback"
        ''}";
        Restart = "on-failure";
      };

      # The service fails to init the first few times,
      # so dealy it to allow for it to start correctly.
      serviceConfig.RestartSec = 5;
    };
  };

}
