.PHONY: darwin home default nixos

default: nixos

darwin:
	nix run nix-darwin -- switch --flake . --show-trace
build_darwin:
	nix run nix-darwin -- build --flake . 

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .

nixos:
	sudo nixos-rebuild switch --flake .

test_nixos:
	sudo nixos-rebuild test --fast --flake .
