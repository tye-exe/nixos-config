{
  config,
  inputs,
  lib,
  pkgs,
  my_opts,
  system,
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

      port = mkOption {
        type = types.int;
        default = 22;
        description = ''
          Target SSH port for remote builder
        '';
      };

      publicKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The public key used to verify the identity of the remote builder.
        '';
      };

      systems = # Switch to lib.uniqueStrings when available
        mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          description = ''
            The systems that the builder can build/emulate, excluding the the builders system.
            If this is left blank, then only the host system will be used. 
          '';
        };

      # Easy hack to transfer which system builder is
      system = mkOption {
        type = types.str;
        default = system;
        description = ''Do not change this.'';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable (
      let
        # A list of systems that are builders
        builderSystems =
          inputs.self.nixosConfigurations
          |> builtins.mapAttrs (_: system: system.config)
          |> lib.attrsets.filterAttrs (_: system: system.networking.hostName != config.networking.hostName)
          |> lib.attrsets.filterAttrs (_: system: system.tye.remote-build.builder.enable)
          |> builtins.attrValues;
      in
      {
        nix.distributedBuilds = true;
        nix.settings.builders-use-substitutes = true;

        # Add ssh config for nix.buildMachines.hostName to reference
        programs.ssh.extraConfig = builtins.foldl' (acc: elm: "${elm}\n") "" (
          builtins.map (
            system:
            let
              builder = system.tye.remote-build.builder;
            in
            ''
              Host nix-remote-builder-${builder.host}
              Hostname ${builder.host}
              Port ${builtins.toString builder.port}
              User remotebuild
            ''
          ) builderSystems
        );

        nix.buildMachines = (
          builtins.map (
            system:
            let
              builder = system.tye.remote-build.builder;
            in
            {
              hostName = "nix-remote-builder-${builder.host}";
              # sshUser = "remotebuild";
              sshKey = "/etc/ssh/ssh_host_ed25519_key";
              systems = builder.systems ++ [ builder.system ];
              protocol = "ssh";
              maxJobs = 3;
              publicHostKey =
                # For some reason this needs to be base64 encoded and nix does not do this for us.
                builtins.readFile
                  (pkgs.runCommandLocal "hostpubkey" { } ''
                    echo "${builder.publicKey}" | base64 -w0 - > $out
                  '').outPath;
            }
          ) builderSystems
        );

      }
    ))

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

      boot.binfmt.emulatedSystems = builtins.filter (x: x != system) cfg.builder.systems;
    })
  ];
}
