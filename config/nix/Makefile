.PHONY: run build genzai
default: build


switch:
	nix run home-manager/master -- switch --flake ~/.local/share/dotfiles/config/nix
build:
	nix run home-manager/master -- build --flake ~/.local/share/dotfiles/config/nix

genzai:
	nix build .#homeConfigurations.genzai
