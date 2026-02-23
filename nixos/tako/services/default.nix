{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
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

    ./affine.nix
    ./attic.nix
    ./excalidraw.nix
    ./flaresolverr.nix
    # ./games
    # ./headscale.nix
    ./immich.nix
    ./kellnr.nix
    # ./llms.nix
    ./matrix
    # ./monitoring.nix
    # ./paperless.nix
    ./prowlarr.nix
    # ./searxng.nix
    # ./shitpost.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
