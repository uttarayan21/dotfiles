{...}: {
  imports = [
    ./excalidraw.nix
    # ./fail2ban.nix
    ./flaresolverr.nix
    # # ./games
    # ./gitea.nix
    ./homepage.nix
    # # ./llama.nix
    # # ./monitoring.nix
    # # ./nextcloud.nix
    # # ./paperless.nix
    ./prowlarr.nix
    # ./resolved.nix
    ./searxng.nix
    # ./headscale.nix
    # ./shitpost.nix
    ./atuin.nix
    ./caddy.nix
    ./authelia.nix
    ./immich.nix
    ./lldap.nix
    ./openssh.nix
    ./tailscale.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
