.PHONY: sys-switch
sys-switch:
	nixos-rebuild switch -I nixos-config=/home/tye/nixos/configuration.nix --flake /home/tye/nixos/#tye-laptop

.PHONY: hm-switch
hm-switch:
	home-manager switch --flake /home/tye/nixos/#tye-laptop

.PHONY: clean
clean:
	nix-collect-garbage -d
