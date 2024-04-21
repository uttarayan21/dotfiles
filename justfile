set dotenv-load

# clean := `git diff-index --quiet --cached HEAD --`
[macos]
install: local
    darwin-rebuild switch --flake .

[linux]
install: local
	NIX_BUILD_CORES=0 sudo nixos-rebuild switch --flake .

[macos]
build:
    nix run nix-darwin -- build --flake . --show-trace

[linux]
build:
    nixos-rebuild build --flake . --show-trace


home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake . --show-trace

[linux]
local:
    nix flake update subflakes
    nix flake update neovim

[macos]
local:
    nix flake lock --update-input subflakes
    nix flake lock --update-input neovim

nvim:
    nix run .#neovim
