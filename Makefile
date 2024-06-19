.PHONY: sys-switch
sys-switch:
	nixos-rebuild switch -I nixos-config=/home/tye/nixos/configuration.nix --flake /home/tye/nixos/#tye

.PHONY: sys-test
sys-test:
	nixos-rebuild test -I nixos-config=/home/tye/nixos/configuration.nix

.PHONY: hm-switch
hm-switch:
	home-manager switch --flake /home/tye/nixos/#tye

.PHONY: clean
clean:
	nix-collect-garbage -d
