set dotenv-load

[macos]
install:
    nix run nix-darwin -- switch --flake .

[linux]
install:
	sudo nixos-rebuild switch --flake .

build:
    nix run nix-darwin -- build --flake . --show-trace


home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .
