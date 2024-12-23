{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "system-manager";
  version = "1.1.0";

  src = lib.fileset.toSource {
    root = ../system-manager;
    fileset = ../system-manager/.;
  };

  cargoLock = {
    lockFile = ../system-manager/Cargo.lock;
  };

  # I'm not going to ask questions...
  cargoHash = "";
}
