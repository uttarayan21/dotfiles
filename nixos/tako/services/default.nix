{...}: {
  imports = [
    # ./caddy.nix
    # ./excalidraw.nix
    # ./fail2ban.nix
    # ./flaresolverr.nix
    # # ./games
    # ./gitea.nix
    # ./homepage.nix
    # # ./llama.nix
    # # ./monitoring.nix
    # # ./nextcloud.nix
    # # ./paperless.nix
    # ./prowlarr.nix
    # ./resolved.nix
    # ./searxng.nix
    # ./headscale.nix
    # ./shitpost.nix
    ./atuin.nix
    # ./immich.nix
    # ./lldap.nix
    # ./authelia.nix
    ./openssh.nix
    ./tailscale.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
