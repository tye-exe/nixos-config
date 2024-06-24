import os

identity = ".identity"
chose_ident = None

# Creates the identity file if it doesn't exist.
if not os.path.isfile(identity):
    chosen_ident = int(input("Identity not configured. Please select what machine to use.\n1 - tye-laptop\n2 - tye-desktop\n:"))

    # Selects identity
    if chosen_ident == 1:
        chosen_ident = "tye-laptop"
    elif chosen_ident == 2:
        chosen_ident = "tye-desktop"
    else:
        exit("invalid option.")
           
    with open(identity, "x") as ident:
        ident.write(chosen_ident)


# Reads the selected identity content from the file
with open(identity, "r") as ident:
    chosen_ident = ident.read()

# The content of the makeFile
makeFileContent = f"""
.PHONY: sys-switch
sys-switch:
	nixos-rebuild switch -I nixos-config=/home/tye/nixos/configuration.nix --flake /home/tye/nixos/#{chosen_ident}

.PHONY: hm-switch
hm-switch:
	home-manager switch --flake /home/tye/nixos/#{chosen_ident}

.PHONY: clean
clean:
	nix-collect-garbage -d
"""

# Writes content to temp file.
with open("Makefile-temp", "w") as temp:
    temp.write(makeFileContent)

# Deletes old make file if it exists.
if os.path.exists("Makefile"):
    os.remove("Makefile")

os.replace("Makefile-temp", "Makefile")
print("Makefile writen")

