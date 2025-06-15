{ ... }:
{
  services.atuin = {
    enable = true;
    port = 8888;
    openFirewall = true;
    openRegistration = false;
    maxHistoryLength = 0; # Unlimited
    database.createLocally = true;
    host = "0.0.0.0";
  };
}
