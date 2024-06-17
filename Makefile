.PHONY: switch
switch:
	nixos-rebuild switch -I nixos-config=/home/tye/nixos/configuration.nix

.PHONY: update
update:
	home-manager switch --flake .#tye

.PHONY: clean
clean:
	nix-collect-garbage -d
