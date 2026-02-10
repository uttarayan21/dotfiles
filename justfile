set dotenv-load


[macos]
install: 
    sudo nix run nix-darwin -- switch --flake .

[linux]
install cores='32':
	sudo nixos-rebuild switch --flake . --builders '' --max-jobs 1 --cores {{cores}}

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


add program:
    echo '{pkgs, ...}: { home.packages = [pkgs.{{program}}];}' > home/programs/{{program}}.nix
    # https://ast-grep.github.io/advanced/pattern-parse.html#incomplete-pattern-code
    # Since the imports doesn't match the whole pattern we need to use the selector binding and the attr expression to match it properly.
    ast-grep run -p '{ imports = [$$$ITEMS] }' --selector binding --rewrite 'imports = [$$$ITEMS ./{{program}}.nix ]' home/programs/default.nix -i
    alejandra fmt home/programs/{{program}}.nix home/programs/default.nix
    git add home/programs/{{program}}.nix 

# add-secret secret:
#     openssl rand -hex 32 | tr -d '\n' | jq -sR | sops set --value-stdin secrets/secrets.yaml {{secret}}
