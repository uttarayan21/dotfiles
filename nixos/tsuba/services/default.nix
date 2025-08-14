{...}: {
  imports = [
    ./tailscale.nix
    ./samba.nix
    ./jellyfin.nix
    ./caddy.nix
    ./servarr.nix
    ./deluge.nix
    ./homeassistant.nix
    ./flaresolverr.nix
    ./caddy.nix
    ./monitoring.nix
    # ./grafana.nix
    # ./dnscrypt.nix
    # ./resolved.nix
    # ./blocky.nix
  ];
}
