{ pkgs, std, ... }: {
  home = {

    # aoc = pkgs.rustPlatform.buildRustPackage rec {

    # };

    packages = with pkgs; [
      # Installs the rust toolchain
      rustc
      # Install well, useful stuff.
      #      rustup
      # Rust LSP
      rust-analyzer
      cargo
      clippy
      # Rust debugger
      lldb
      # Live debugger
      bacon
      # Creates cache

      # Mold as rust linker
      clang
      mold
    ];

    file."rustup_config" = {
      target = ".rustup/settings.toml";
      text = std.serde.toTOML {
        default_toolchain = "stable-x86_64-unknown-linux-gnu";
        profile = "default";
        version = "12";
      };
    };

    file."cargo_config" = {
      target = ".cargo/config.toml";
      text = std.serde.toTOML {
        target.stable-x86_64-unknown-linux-gnu = {
          linker = "${pkgs.clang}/bin/clang";
          rustflags = ''["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]'';
        };
      };
    };
  };
}
