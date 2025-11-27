{...}: {
  imports = [
    # ./authelia.nix
    # ./caddy.nix
    # ./excalidraw.nix
    # ./fail2ban.nix
    # ./flaresolverr.nix
    # # ./games
    # ./gitea.nix
    # ./homepage.nix
    # # ./llama.nix
    # ./lldap.nix
    # # ./monitoring.nix
    # # ./nextcloud.nix
    # # ./paperless.nix
    # ./prowlarr.nix
    # ./resolved.nix
    # ./searxng.nix
    # ./headscale.nix
    # ./shitpost.nix
    ./atuin.nix
    ./immich.nix
    ./openssh.nix
    ./tailscale.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
