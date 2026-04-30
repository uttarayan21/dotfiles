{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./kobo.nix
    ./caddy.nix
    ./fail2ban.nix
    ./homepage.nix
    ./lldap.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./openssh.nix
    ./resolved.nix
    ./tailscale.nix
    ./gitea.nix
    ./knot.nix

    # ./affine.nix
    ./harmonia.nix
    ./excalidraw.nix
    ./flaresolverr.nix
    # ./games
    # ./headscale.nix
    ./immich.nix
    ./kellnr.nix
    ./komga.nix
    ./llms.nix
    ./matrix
    ./monitoring.nix
    ./octodns.nix
    # ./servius-website.nix
    # ./paperless.nix
    ./prowlarr.nix
    # ./searxng.nix
    ./shitpost.nix
    ./vaultwarden.nix
  ];
}
