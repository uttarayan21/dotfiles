{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./excalidraw.nix
    ./fail2ban.nix
    ./flaresolverr.nix
    ./gitea.nix
    ./homepage.nix
    ./immich.nix
    ./llama.nix
    ./lldap.nix
    ./monitoring.nix
    ./nextcloud.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./tailscale.nix
    ./games
    # ./paperless.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
