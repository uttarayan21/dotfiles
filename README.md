# Dotfiles

NixOS, nix-darwin, and Home Manager configurations across personal machines.

## Machines

| Host  | Role             | Hardware                                              | Deploy             |
| ----- | ---------------- | ----------------------------------------------------- | ------------------ |
| ryu   | Linux desktop    | Intel i9-14900KS / RTX 5090 / 64GB DDR5 CL36@6000MT/s | `deploy -s .#ryu`   |
| tako  | Linux server     | Intel Xeon E-2236 / 64GB DDR5                         | `deploy -s .#tako`  |
| tsuba | Linux server     | Raspberry Pi 5 / 8GB                                  | `deploy -s .#tsuba` |
| kuro  | macOS laptop     | Apple M4 Pro MacBook / 24GB                           | `deploy -s .#kuro`  |
| shiro | macOS desktop    | Apple M4 Mac mini / 16GB                              | `deploy -s .#shiro` |

## Layout

- `flake.nix` — entry point and device definitions
- `nixos/` — per-host NixOS configs (`ryu`, `tako`, `tsuba`)
- `darwin/` — per-host nix-darwin configs (`kuro`, `shiro`)
- `home/` — Home Manager modules (`programs/`, `services/`, `apps/`)
- `modules/` — custom modules (`nixos/`, `darwin/`, `home/`)
- `secrets/` — SOPS-encrypted secrets
- `steamdeck/` — standalone Home Manager config for Steam Deck

## Validating

```bash
nixos-rebuild build --flake .       # current Linux host
darwin-rebuild build --flake .      # current macOS host
alejandra fmt .                     # format all Nix files
```

## Troubleshooting

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

## TODO

- Verify Gitea Actions `nix copy` from shiro to tako still works after dropping `gitea-runner` from tako's `nix.settings.trusted-users`. Paths must be signed by `cache.shiro-1` (shiro's `secret-key-files`); unsigned imports or `--no-check-sigs` will fail for non-trusted users.
