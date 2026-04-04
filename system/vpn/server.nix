{
  config,
  name,
  opts,
  lib,
  ...
}:
let
  port = 51820;
  interface = "wg0";
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
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eno1";
    internalInterfaces = [ interface ];
  };

  systemd.network = {
    enable = true;

    networks."50-${interface}" = {
      matchConfig.Name = interface;

      address = [
        # /32 and /128 specifies a single address
        # for use on this wg peer machine
        # "fd31:bf08:57cb::1/128"
        # "192.168.2.1/32"
        "::/0"
        "0.0.0.0/0"
      ];

      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };

    netdevs."50-${interface}" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = interface;
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
      wireguardPeers =
        opts.keys.wireguard.client
        |> builtins.attrValues
        |> lib.lists.imap1 (
          index: key: {
            PublicKey = key;
            AllowedIPs = [
              # Index + 1 because server is at 1.
              "fd31:bf08:57cb::${toString (index + 1)}/128"
              "192.168.2.${toString (index + 1)}/32"
            ];

            # RouteTable can also be set in wireguardPeers
            # RouteTable in wireguardConfig will then be ignored.
            # RouteTable = 1000;
          }
        );
    };
  };

}
