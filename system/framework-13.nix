{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    ./core.nix
    ./de/de.nix
    ./virtualization.nix
    inputs.sops-nix.nixosModules.sops
  ];

  networking.firewall = {
    enable = true;
    # Required for windows connecting form inside container.
    allowedTCPPorts = [ 14240 ];
  };

  networking.hostName = "framework"; # Define your hostname.
  hardware.bluetooth.enable = true;

  # On screen keyboards work alot better in X
  services.xserver.enable = true;

  services.touchegg.enable = true;

  services.flatpak.enable = true;

  # Program configs
  programs = {
    # Steam has to be managed in config.nix due to some system-wide settings being modified
    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  users.users.work = {
    isNormalUser = true;
    description = "work";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
    hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
  };

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
        # Optionally customize rootless Docker daemon settings
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  environment.defaultPackages = with pkgs; [ podman-compose ];

  system.stateVersion = "25.11";

  # Allow decryption of swap
  boot.initrd.luks.devices."luks-ff21dae6-bab5-49d2-b6e3-77b6533f42fe".device =
    "/dev/disk/by-uuid/ff21dae6-bab5-49d2-b6e3-77b6533f42fe";

  services.fprintd.enable = true;
}
