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
    ./zerotier.nix

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
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
