#!/usr/bin/env bash

# Terminate script if any command fails.
set -eo pipefail

# Only continues execution if sudo permission is granted.
sudo echo "Sudo permission granted."

# Download repo & move into it.
git clone https://github.com/tye-exe/nixos-config.git
cd nixos-config

# Sets the lua script to be executable.
chmod +x core.lua 

# Prints my logo; This can be removed if desired.
./core.lua logo

# Generate hardware conf for this machine.
echo "Generating hardware configuration for this machine."
nixos-generate-config --show-hardware-config >> ./hardware-confs/undefined.nix

echo "Switching system configuration."
eval ./core.lua sys-switch | sudo bash

echo "Switching home-manager configuration."
eval ./core.lua undefined-hm-switch | bash

echo "Finished configuration system & dot files; Reboot to allow for configuration to take full effect."
