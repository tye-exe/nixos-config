{ ... }:
{
  imports = [
    ./core.nix
    # Keep the desktop for a GUI environment.
    # I assume that people will want this.
    ./preset/de.nix
  ];
}
