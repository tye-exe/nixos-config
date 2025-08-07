{ ... }:
{
  # Core configuration file.
  imports = [ ./core.nix ];

  programs.chromium.enable = false;
}
