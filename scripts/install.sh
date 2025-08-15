#!/usr/bin/env bash

# Terminate script if any command fails.
set -eo pipefail

echo "Sudo required to change system configuration"
# Only continues execution if sudo permission is granted.
sudo echo "Sudo permission granted."

# Check if repo has already been cloned.
if [ -d "nixos-config" ]; then
  echo "Repo found; updating"
  cd nixos-config
  git pull
else
  echo "Cloning repo."
  # Download repo & move into it.
  git clone https://github.com/tye-exe/nixos-config.git
  cd nixos-config
fi

# Prints my logo; This can be removed if desired.
system-manager logo

# Sets the identity to undefined
system-manager identity set undefined

# Sets the current path as the path to the configuration.
system-manager path set .

# Generate hardware conf for this machine.
echo "Generating hardware configuration for this machine."
nixos-generate-config --show-hardware-config > ./hardware-confs/undefined.nix
# A file needs to be added to git for nix flakes to access it.
git add ./hardware-confs/undefined.nix

echo "Switching system configuration."
system-manager switch system

echo "Switching home-manager configuration."
system-manager switch home

echo "Finished configuring system & dot files; Reboot to allow for the configuration to take full effect."
