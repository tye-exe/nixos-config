.PHONY: switch
switch:
	nixos-rebuild switch -I nixos-config=/home/tye/nixos/configuration.nix

.PHONY: test
test:
	nixos-rebuild test -I nixos-config=/home/tye/nixos/configuration.nix

.PHONY: update
update:
	home-manager switch --flake /home/tye/nixos/home-manager/#tye

.PHONY: clean
clean:
	nix-collect-garbage -d
