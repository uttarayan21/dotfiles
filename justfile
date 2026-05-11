set dotenv-load



[macos]
install: 
    sudo nix run nix-darwin -- switch --flake .

[linux]
install cores='32':
	sudo nixos-rebuild switch --flake . --builders '' --max-jobs 1 --cores {{cores}}

[linux]
boot cores='32': 
	sudo nixos-rebuild boot --flake . --builders '' --max-jobs 1 --cores {{cores}}

[macos]
build host=`hostname` cores='32':
    nix run nix-darwin -- build --flake .#{{host}} --show-trace --max-jobs 1 --cores {{cores}}

[linux]
build host=`hostname` cores='12':
    nixos-rebuild build --flake .#{{host}} --show-trace --max-jobs 1 --cores {{cores}} --substituters ''

nix args:
    nix --extra-experimental-features "nix-command flakes" {{args}}

home:
	nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake . --show-trace


nvim:
    nix run .#neovim


[linux]
rollback:
	sudo nixos-rebuild switch --rollback --flake .


add path name:
    #!/usr/bin/env bash
    set -euo pipefail
    machine=$(echo "{{path}}" | cut -d/ -f1)
    category=$(echo "{{path}}" | cut -d/ -f2)
    case "$machine" in
        ryu|tako|tsuba) dir="nixos/$machine/$category" ;;
        kuro|shiro)     dir="darwin/$machine/$category" ;;
        home)           dir="home/$category" ;;
        *)              echo "Unknown machine/path: $machine"; exit 1 ;;
    esac
    echo '{...}: { }' > "$dir/{{name}}.nix"
    # https://ast-grep.github.io/advanced/pattern-parse.html#incomplete-pattern-code
    # Since the imports doesn't match the whole pattern we need to use the selector binding and the attr expression to match it properly.
    if [ -t 0 ] && [ -t 1 ]; then sg_flag=-i; else sg_flag=-U; fi
    ast-grep run -p '{ imports = [$$$ITEMS] }' --selector binding --rewrite 'imports = [$$$ITEMS ./{{name}}.nix ]' "$dir/default.nix" "$sg_flag"
    alejandra fmt "$dir/{{name}}.nix" "$dir/default.nix"
    git add "$dir/{{name}}.nix"

# add-secret secret:
#     openssl rand -hex 32 | tr -d '\n' | jq -sR | sops set --value-stdin secrets/secrets.yaml {{secret}}
