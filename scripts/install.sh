#!/usr/bin/env bash
bash

# Download repo & move into it.
git clone https://github.com/tye-exe/nixos-config.git
cd nixos-config

# Sets the lua script to be executable.
chmod +x core.lua 

# Prints my logo; This can be removed if desired.
eval ./core.lua logo

# Generate hardware conf for this machine.
echo "Generating hardware configuration for this machine."
nixos-generate-config --show-hardware-config >> ./hardware-confs/undefined.nix

echo "Switching system configuration."
sudo eval ./core.lua undefined-sys-switch

echo "Switching home-manager configuration."
eval ./core.lua undefined-hm-switch

echo "Finished configuration system & dot files; Reboot to allow for configuration to take full effect."
