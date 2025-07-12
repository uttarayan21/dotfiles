{...}: {
  imports = [
    ./tailscale.nix
    ./samba.nix
    ./jellyfin.nix
    ./caddy.nix
    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
    ./deluge.nix
  ];
}
