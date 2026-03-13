{...}: {
  imports = [
    ./tailscale.nix
    ./samba.nix
    ./jellyfin.nix
    ./caddy.nix
    ./servarr.nix
    ./deluge.nix
    ./aria2.nix
    ./homeassistant.nix
    ./flaresolverr.nix
    ./caddy.nix
    ./monitoring.nix
    ./pihole.nix
    ./resolved.nix
    ./docker.nix
  ];
}
