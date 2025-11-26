{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./excalidraw.nix
    ./fail2ban.nix
    ./flaresolverr.nix
    # ./games
    ./gitea.nix
    ./homepage.nix
    # ./immich.nix
    ./immich.nix
    # ./llama.nix
    ./lldap.nix
    # ./monitoring.nix
    # ./nextcloud.nix
    # ./paperless.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./tailscale.nix
    # ./headscale.nix
    # ./shitpost.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
