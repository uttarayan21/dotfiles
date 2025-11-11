set dotenv-load

[macos]
install: 
    sudo nix run nix-darwin -- switch --flake .

[linux]
install:
	NIX_BUILD_CORES=32 sudo nixos-rebuild switch --impure --flake . --builders ''

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


[linux]
rollback:
	sudo nixos-rebuild switch --rollback --flake .
