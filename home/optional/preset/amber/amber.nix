{
  lib,
  pkgs,
  ...
}:

pkgs.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber-lsp";
  version = "0.1.9";

  src = pkgs.fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rVh79myF1kfYY0P8hq8ZPNXOkhGvyZZzv8SFYfRJKy8=";
  };

  # Upstream does not include lock file
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chumsky-1.0.0-alpha.7" = "sha256-eF48NeuUHdpwNf5+Ura6P7aXfCWHd/rziQTOomaPoic=";
    };
  };
  postPatch = ''ln -s ${./Cargo.lock} Cargo.lock'';

  meta = {
    description = "Official language server for the Amber programming language";
    mainProgram = finalAttrs.pname;
    homepage = "https://github.com/amber-lang/amber-lsp";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tye-exe ];
  };
})
