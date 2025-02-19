set dotenv-load

# clean := `git diff-index --quiet --cached HEAD --`
[macos]
install: 
    nix run nix-darwin -- switch --flake .

[linux]
install:
	NIX_BUILD_CORES=0 sudo nixos-rebuild switch --flake .

[macos]
build:
    nix run nix-darwin -- build --flake . --show-trace

[linux]
build:
    nixos-rebuild build --flake . --show-trace

nix args:
    nix --extra-experimental-features "nix-command flakes" {{args}}

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake . --show-trace


nvim:
    nix run .#neovim
