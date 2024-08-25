# tye - nix
```
------------------------------------------------------------------
 ______   __  __     ______           __   __     __     __  __
/\__  _\ /\ \_\ \   /\  ___\         /\ "-.\ \   /\ \   /\_\_\_\
\/_/\ \/ \ \____ \  \ \  __\         \ \ \-.  \  \ \ \  \/_/\_\/_
   \ \_\  \/\_____\  \ \_____\        \ \_\\"\_\  \ \_\   /\_\/\_\
    \/_/   \/_____/   \/_____/         \/_/ \/_/   \/_/   \/_/\/_/

------------------------------------------------------------------
```

### Install instructions
```bash
# This script is written for bash.
bash

# Prerequisites to initialise configuration.
nix-shell -p git lua

# Download repo & move into it.
git clone https://github.com/tye-exe/nixos-config.git
cd nixos-config

# Generate hardware conf for this machine.
nixos-generate-config --show-hardware-config >> ./hardware-confs/undefined.nix

# Sets the lua script to be executable.
chmod +x core.lua 

# Prints my logo; This can be removed if desired.
eval ./core.lua logo

echo "Switching system configuration:"
sudo eval ./core.lua undefined-sys-switch

echo "Switching home-manager configuration:"
eval ./core.lua undefined-hm-switch

echo "Finished configuration system & dot files; Reboot to allow for configuration to take full effect."
```

### Change configuration location
If you wish to change the repo location, then move `nixos-config` to the desired folder/path of your
choosing & execute `bash; eval ./core.lua undefined-hm-switch` within the new directory & nix will update the
required paths.
