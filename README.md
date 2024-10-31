# TYE - NIX
```
------------------------------------------------------------------
 ______   __  __     ______           __   __     __     __  __
/\__  _\ /\ \_\ \   /\  ___\         /\ "-.\ \   /\ \   /\_\_\_\
\/_/\ \/ \ \____ \  \ \  __\         \ \ \-.  \  \ \ \  \/_/\_\/_
   \ \_\  \/\_____\  \ \_____\        \ \_\\"\_\  \ \_\   /\_\/\_\
    \/_/   \/_____/   \/_____/         \/_/ \/_/   \/_/   \/_/\/_/

------------------------------------------------------------------
```

### Install Command
```bash
curl -sL https://tye-home.xyz/nix-init | bash
```
The above URL is a redirect for:
[https://raw.githubusercontent.com/tye-exe/nixos-config/main/scripts/init.sh](https://raw.githubusercontent.com/tye-exe/nixos-config/main/scripts/init.sh) 
This is just to reduce the effort when typing the install command into a terminal.

If you wish to download directly from github, then use the following command instead:
```bash
curl -s https://raw.githubusercontent.com/tye-exe/nixos-config/main/scripts/init.sh | bash
```

### Change Configuration Location
If you wish to change the repo location, then move **all** the files (including dot files) within `nixos-config`
to the desired folder/path of your choosing & execute `./core.lua hm-switch` within the new directory & nix will
update the required paths.

### Basic Usage
```bash
# Executes 'nixos-rebuild switch'.
sys-switch
```
```bash
# Executes 'home-manager switch'.
hm-switch
```

### Advanced Usage
```bash
# Prompts for changing the identity of the system.
set-identity
```
```bash
cd <nix-config>
# Shows available commands to execute on the core.lua file directly.
./core.lua help
```
