{ config, ... }:
{
  power.ups = {
    enable = true;
    mode = "standalone";
    ups."myups" = {
      driver = "usbhid-ups";
      port = "auto";
    };

    users = {
      "admin" = {
        upsmon = "primary";
        passwordFile = config.sops.secrets."upsmon".path;
        instcmds = [ "all" ];
        actions = [
          "set"
          "fsd"
        ];
      };
    };

    upsmon = {
      enable = true;
      monitor = {
        "admin" = {
          user = "admin";
          powerValue = 1;
          passwordFile = config.sops.secrets."upsmon".path;
          system = "myups";
        };
      };
    };
  };
}
