{
  pkgs,
  inputs,
  lib,
  system,
  name,
  config,
  opts,
  ...
}:

{
  imports = [
    ./utils.nix
    inputs.sops-nix.nixosModules.sops
  ];

  # Sops setup.
  sops.defaultSopsFile = ./../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${config.users.users.tye.name}/.config/sops/age/keys.txt";

  sops.secrets = {
    upsmon = { };
    initialHashedPassword.neededForUsers = true;
  };

  # Bootloader.
  boot.loader = lib.mkIf (name != "rpi") (
    lib.mkDefault {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    }
  );

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  # Use my flake for nix evaulations.
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  documentation.man.generateCaches = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "9.9.9.9"
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  security.rtkit.enable = true;

  # Keyboard configuration
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tye = {
    isNormalUser = true;
    description = "tye";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = opts.keys.users;
    hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
  };

  # Allow use of docker without sudo
  users.groups.docker.members = [ config.users.users.tye.name ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # Vim-like editor
    home-manager # Manages user-configurations
    libxkbcommon # Keyboard library - required by some programs
    wget
    sops # Secrets management

    inputs.system-manager.packages.${system}.system-manager
  ];

  environment.variables = {
    EDITOR = "hx";
  };

  # Program configs.
  programs = {
    git = {
      enable = true;
      config = {
        # Allow home-manager building from other users
        safe.directory = [ "/etc/nixos" ];

        # Default to personal details
        user = {
          name = "tye-exe";
          email = "tye@mailbox.org";
        };

        core = {
          editor = "${pkgs.helix}/bin/hx";
          compression = 9;
          preloadIndex = true;
        };
      };
    };

    fish.enable = true; # Here due to login shell shenanigans
    dconf.enable = true; # Used for Easyeffects

    firefox = {
      enable = lib.mkDefault true;
      # Resting fingerprinting sadly messes with too many things
      # This is to disable it
      preferences = {
        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.pbmode" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
      };
    };

    # Bash will still be the default shell, but will hand over to fish.
    # This is because some login methods expect a bash shell.
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

  };

  # List services that you want to enable:

  # Enables system-resolved : essential for wireguard.
  services.resolved.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 3333 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "24.05"; # Did you read the comment?
}
