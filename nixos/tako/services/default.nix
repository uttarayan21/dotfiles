{...}: {
  imports = [
    # ./games
    # ./headscale.nix
    # ./llama.nix
    # ./monitoring.nix
    # ./paperless.nix
    ./shitpost.nix
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./excalidraw.nix
    ./fail2ban.nix
    ./flaresolverr.nix
    ./gitea.nix
    ./homepage.nix
    ./immich.nix
    ./lldap.nix
    ./nextcloud.nix
    ./openssh.nix
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./tailscale.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
