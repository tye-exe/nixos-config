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
to the desired folder/path of your choosing & execute:
```bash
system-manager path <New Config Path> # Can be relative, such as "." if it is the current working dir.
```
It is also recommended to perform a system switch & a home-manager switch [see Basic Usage](#Basic-Usage)

### Basic Usage
```bash
# Executes 'nixos-rebuild switch'.
system-manager switch system
```
```bash
# Executes 'home-manager switch'.
system-manager switch home
```
For further help:
```bash
system-manager --help
```

### Advanced Usage
```bash
# Prompts for changing the identity of the system.
system-manager identity set <Identity>
```
