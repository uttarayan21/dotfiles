set dotenv-load

[macos]
install:
    nix run nix-darwin -- switch --flake .

[linux]
install:
	sudo nixos-rebuild switch --flake .

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .
