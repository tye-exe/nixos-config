{
  rustPlatform,
  fetchgit,
}:

rustPlatform.buildRustPackage rec {
  pname = "system-manager";
  version = "1.2.0";

  src = fetchgit {
    url = "https://github.com/tye-exe/nixos-config";
    sparseCheckout = [
      "system-manager"
    ];
    hash = "sha256-N9vViG6X7o1e3uo6fpWDM9wfssKb1KI1ayOGtI3+qV4=";
  };

  sourceRoot = "${src.name}/system-manager";

  cargoHash = "sha256-wJw3LLdm08u484HOOXedRwsW8jTAJovIdczgTJOlXyQ=";
}
