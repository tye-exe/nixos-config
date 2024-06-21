{ pkgs, std, ... }: {
  home = {

    # aoc = pkgs.rustPlatform.buildRustPackage rec {

    # };

    packages = with pkgs; [
      # Installs the rust toolchain
      rustup
      # Rust debugger
      lldb
      # Live debugger
      bacon
      # Creates cache

    ];

    # file."test" = {
    #   text = std.serde.toTOML {
    #     test.one = "E!";
    #     test.two = "Two";
    #     eh = "nah";
    #   };
    # };
  };
}
