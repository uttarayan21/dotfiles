set dotenv-load

# clean := `git diff-index --quiet --cached HEAD --`
[macos]
install: local
    nix run nix-darwin -- switch --flake .

[linux]
install: local
	sudo nixos-rebuild switch --flake .

build:
    nix run nix-darwin -- build --flake . --show-trace


home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake . --show-trace

local:
    nix flake update subflakes
    nix flake update neovim

nvim:
    nix run .#neovim
