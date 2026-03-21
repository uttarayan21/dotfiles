{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./kobo.nix
    ./caddy.nix
    # ./calibre.nix
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

    ./affine.nix
    ./attic.nix
    ./excalidraw.nix
    ./flaresolverr.nix
    # ./games
    # ./headscale.nix
    ./immich.nix
    ./kellnr.nix
    ./llms.nix
    ./matrix
    ./monitoring.nix
    # ./servius-website.nix
    # ./paperless.nix
    ./prowlarr.nix
    # ./searxng.nix
    ./shitpost.nix
    ./vaultwarden.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
