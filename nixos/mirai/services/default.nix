{ ... }:
{
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
    ./prowlarr.nix
    ./resolved.nix
    ./searxng.nix
    ./tailscale.nix
    # ./grafana.nix

    ./excalidraw.nix
    # ./desmos.nix
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
