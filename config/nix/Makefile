.PHONY: darwin home default nixos

default: nixos

darwin:
	# nix run nix-darwin 			-- switch --flake ~/.local/share/dotfiles/config/nix
	nix run nix-darwin -- switch --flake .

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .

nixos:
	sudo nixos-rebuild switch --flake .
