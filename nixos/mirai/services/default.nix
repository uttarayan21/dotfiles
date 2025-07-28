{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./caddy.nix
    ./fail2ban.nix
    ./gitea.nix
    ./homepage.nix
    ./llama.nix
    ./minecraft.nix
    ./nextcloud.nix
    ./tailscale.nix
    ./prowlarr.nix
    ./flaresolverr.nix
    ./searxng.nix
    ./immich.nix
    ./ldap.nix

    # ./home-assistant.nix
    # ./jellyfin.nix
    # ./ldap.nix
    # ./llama.nix
    # ./navidrome.nix
    # ./nextcloud.nix
    # ./paperless.nix
    # ./polaris.nix
    # ./seafile.nix
    # ./syncthing.nix
    # ./vscode.nix
    # ./zerotier.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
