{ pkgs, std, ... }: {
  home = {

    # aoc = pkgs.rustPlatform.buildRustPackage rec {

    # };

    packages = with pkgs; [
      rustc
      rust-analyzer
      cargo
      clang

      # Rust linter
      clippy
      # Rust debugger
      lldb
      # Live debugger
      bacon
      # Crate cache
      sccache
      # Rust linker
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
        # Build with mold to reduce link time.
        target.x86_64-unknown-linux-gnu = {
          rustflags = [ "-C" "link-arg=--ld-path=${pkgs.mold}/bin/mold" ];
        };
        # Cache of built crates to reduce compile time.
        build = {
          rustc-wrapper = "${pkgs.sccache}/bin/sccache";
          incremental = false;
        };
      };
    };
  };
}
