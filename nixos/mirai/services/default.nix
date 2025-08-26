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
    ./nextcloud.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./sigmabot.nix
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
