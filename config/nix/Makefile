.PHONY: darwin home default 

default: home

darwin:
	nix run nix-darwin 			-- switch --flake ~/.local/share/dotfiles/config/nix

home:
	nix run home-manager/master -- switch --flake ~/.local/share/dotfiles/config/nix

