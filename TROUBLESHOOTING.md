# Troubleshooting

## tako can't reach its own services (NAT hairpin)

`*.darksailor.dev` resolves to tako's external IP (`nixos/dns-shared.nix`). When tako itself queries one of those names — Glance status checks, Nix fetching from `cache.darksailor.dev`, etc. — the connection loops back to its own WAN IP and fails (no NAT hairpin on the upstream router).

**Fix in tree:** `nixos/tako/services/caddy.nix` adds every Caddy vhost to `/etc/hosts` pointing at `127.0.0.1`:

```nix
networking.hosts."127.0.0.1" = lib.attrNames config.services.caddy.virtualHosts;
```

So tako always reaches local Caddy directly with valid LE certs.

**Caveat:** if a Caddy vhost on tako is ever meant to proxy *to a different host*, this will shadow it — exclude that name explicitly.

## BB_Launcher: "Only one instance of app can be opened"

BB_Launcher uses shared memory (shm) for single-instance detection. If it crashes or is killed without cleanup, stale shm segments remain and block relaunch.

**Fix:** Remove the orphaned shared memory segments:
```bash
# List segments to identify BB_Launcher's (owned by your user)
ipcs -m

# Remove by shmid (replace 0 and 1 with actual shmid values)
ipcrm -m 0
ipcrm -m 1
```

## shiro pulls GHC (Haskell) during system build

`pkgs.writeShellApplication` runs shellcheck at build time as part of `nativeBuildInputs`. `shellcheck-*-bin` for `aarch64-darwin` is not in `cache.nixos.org`, so it builds from source — which pulls GHC (~2.5 GiB unpacked).

**Fix in tree:** `darwin/shiro/services/gitea-runner.nix` uses `pkgs.writeShellScriptBin` instead and prepends `lib.makeBinPath` to `PATH` manually. `checkPhase = "true"` is not enough — shellcheck stays in `nativeBuildInputs` regardless.
