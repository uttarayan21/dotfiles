.PHONY: darwin home default nixos install

default: install

install:
	sudo nixos-rebuild switch --flake . --builders '' --max-jobs 1

build:
	sudo nixos-rebuild build --flake . --show-trace

local:
	just local

darwin:
	nix run nix-darwin -- switch --flake . --show-trace
build_darwin:
	nix run nix-darwin -- build --flake . 

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .#mirai -b backup

nixos:
	sudo nixos-rebuild switch --flake . -j 1

deck:
	nix run home-manager/master -- switch --flake .#deck
	

test_nixos:
	sudo nixos-rebuild test --fast --flake .
