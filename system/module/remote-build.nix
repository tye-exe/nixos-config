{
  config,
  inputs,
  lib,
  pkgs,
  my_opts,
  ...
}:
let
  cfg = config.tye.remote-build;
in
{
  options.tye.remote-build = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Common config for servers.
      '';
    };

    builder = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow other systems to use this machine to remotely build.
        '';
      };

      host = mkOption {
        type = types.str;
        default = lib.strings.stringAsChars (c: if c == "-" then "." else c) config.networking.hostName;
        description = ''
          The host other systems should use to connect to this remote builder.
        '';
      };

      publicKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The public key used to verify the identity of the remote builder.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      nix.distributedBuilds = true;
      nix.settings.builders-use-substitutes = true;

      nix.buildMachines =
        inputs.self.nixosConfigurations
        |> builtins.mapAttrs (_: system: system.config)
        |> lib.attrsets.filterAttrs (_: system: system.networking.hostName != config.networking.hostName)
        |> lib.attrsets.filterAttrs (_: system: system.tye.remote-build.builder.enable)
        |> builtins.attrValues
        |> (builtins.map (system: {
          hostName = system.tye.remote-build.builder.host;
          sshUser = "remotebuild";
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          system = system.nixpkgs.hostPlatform.system;
          protocol = "ssh-ng";
          maxJobs = 3;
          publicHostKey =
            # For some reason this needs to be base64 encoded and nix does not do this for us.
            builtins.readFile
              (pkgs.runCommandLocal "hostpubkey" { } ''
                echo "${system.tye.remote-build.builder.publicKey}" | base64 -w0 - > $out
              '').outPath;
        }));

    })

    (lib.mkIf cfg.builder.enable {
      users.users.remotebuild = {
        isNormalUser = true;
        createHome = false;
        password = "!";
        group = "remotebuild";

        shell = pkgs.bash;
        openssh.authorizedKeys.keys = my_opts.keys.all;
      };

      users.groups.remotebuild = { };

      nix = {
        nrBuildUsers = 64;
        settings = {
          trusted-users = [ "remotebuild" ];

          min-free = 64 * 1024 * 1024;
          max-free = 256 * 1024 * 1024;
          max-jobs = "auto";
          cores = 0;
        };
      };

      systemd.services.nix-daemon.serviceConfig = {
        MemoryAccounting = true;
        MemoryMax = "60%";
        OOMScoreAdjust = 500;
      };
    })
  ];
}
