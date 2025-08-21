{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./fail2ban.nix
    ./flaresolverr.nix
    ./gitea.nix
    ./homepage.nix
    ./immich.nix
    ./llama.nix
    ./lldap.nix
    ./minecraft.nix

    ./nextcloud.nix
    ./paperless.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./tailscale.nix
    ./excalidraw.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
