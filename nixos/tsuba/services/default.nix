{...}: {
  imports = [
    ./tailscale.nix
    ./samba.nix
    ./jellyfin.nix
    ./caddy.nix
    ./servarr.nix
    ./deluge.nix
    ./homeassistant.nix
    # ./dnscrypt.nix
    ./resolved.nix
  ];
}
