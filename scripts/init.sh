#!/usr/bin/env bash

# Prerequisites to initialise configuration.
nix --extra-experimental-features "nix-command flakes" \
shell nixpkgs#git nixpkgs#lua nixpkgs#curl nipkgs#bash \
--command sh -c "curl -s https://raw.githubusercontent.com/tye-exe/nixos-config/main/scripts/install.sh | bash"
