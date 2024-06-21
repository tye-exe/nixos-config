{ pkgs, std, ... }: {
  home = {

    # aoc = pkgs.rustPlatform.buildRustPackage rec {

    # };

    packages = with pkgs; [
      # Installs the rust toolchain
      rustc
      # Install well, useful stuff.
      rustup
      # Rust debugger
      lldb
      # Live debugger
      bacon
      # Creates cache

    ];

    file."settings.toml" = {
      target = ".rustup/settings.toml";
      text = std.serde.toTOML {
        default_toolchain = "stable-x86_64-unknown-linux-gnu";
        profile = "default";
        version = "12";
      };
    };
  };
}
