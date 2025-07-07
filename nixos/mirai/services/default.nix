{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./llama.nix
    ./minecraft.nix
    ./tailscale.nix
    ./zerotier.nix
    ./caddy.nix
    ./fail2ban.nix
    ./gitea.nix
    ./homepage.nix
    # ./nextcloud.nix

    # ./navidrome.nix
    # ./home-assistant.nix
    # ./jellyfin.nix
    # ./polaris.nix
    # ./syncthing.nix
    # ./vscode.nix
    # ./ldap.nix
    # ./llama.nix
    # ./nextcloud.nix
    # ./seafile.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
