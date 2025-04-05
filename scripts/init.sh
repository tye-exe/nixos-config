#!/usr/bin/env bash

# Prerequisites to initialise configuration.
nix --extra-experimental-features "nix-command flakes" \
shell nixpkgs#git nixpkgs#curl nixpkgs#bash github:tye-exe/nixos-conf#system-manager  \
--command sh -c "curl -s https://raw.githubusercontent.com/tye-exe/nixos-config/main/scripts/install.sh | bash"
