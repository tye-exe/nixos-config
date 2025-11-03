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

  networking.hostName = "framework"; # Define your hostname.
  hardware.bluetooth.enable = true;

  # On screen keyboards work alot better in X
  services.xserver.enable = true;
  environment.systemPackages = with pkgs; [
    onboard
  ];

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
    ];
    hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
  };
}
