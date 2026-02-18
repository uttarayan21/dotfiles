{...}: {
  imports = [
    ./affine.nix
    ./attic.nix
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./excalidraw.nix
    ./fail2ban.nix
    ./flaresolverr.nix
    ./games
    ./gitea.nix
    ./homepage.nix
    ./immich.nix
    ./kellnr.nix
    ./lldap.nix
    ./llms.nix
    ./matrix
    ./monitoring.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./openssh.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./shitpost.nix
    ./tailscale.nix
    # ./headscale.nix
    # ./paperless.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
