{
  config,
  name,
  opts,
  lib,
  ...
}:
let
  port = 51820;
in
{
  sops.secrets."${name}/wireguard" = {
    # for permission, see man systemd.netdev
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ port ];
  networking.useNetworkd = true;

  # NixOS firewall will block wg traffic because of rpfilter
  networking.firewall.checkReversePath = "loose";

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";

      address =
        opts.keys.wireguard.client
        |> builtins.attrNames
        |> lib.lists.imap1 (
          index: name: {
            name = name;
            address = [
              # Index + 1 because server is at 1.
              "fd31:bf08:57cb::${toString (index + 1)}/128"
              "192.168.2.${toString (index + 1)}/32"
            ];
          }
        )
        |> builtins.filter (ele: ele.name == name)
        |> map (ele: ele.address)
        |> lib.flatten;
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = port;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.sops.secrets."${name}/wireguard".path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = opts.keys.wireguard.server;
          # All traffic
          AllowedIPs = [
            "::/0"
            "0.0.0.0/0"
          ];
          Endpoint = "tye-home.xyz:${toString port}";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };

}
