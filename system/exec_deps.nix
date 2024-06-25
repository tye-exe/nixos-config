{ pkgs, ... }: {
  # Enables dynamically linked executables to run.
  programs.nix-ld.enable = true;

  # Add any missing dynamic libraries for unpackaged 
  # programs here, NOT in environment.systemPackages
  programs.nix-ld.libraries = with pkgs; [ dotnet-runtime_8 ];

}
