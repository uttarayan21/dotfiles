{...}: {
  imports = [
    ./tailscale.nix
    ./samba.nix
    ./jellyfin.nix
    ./caddy.nix
    ./servarr.nix
    # ./sonarr.nix
    # ./radarr.nix
    # ./prowlarr.nix
    ./deluge.nix
    ./homeassistant.nix
  ];
}
