{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    ./jellyfin.nix
    ./llama.nix
    ./minecraft.nix
    ./tailscale.nix
    ./caddy.nix
    ./fail2ban.nix

    # ./polaris.nix
    # ./seafile.nix
    # ./syncthing.nix
    # ./vscode.nix
    # ./nextcloud.nix
    # ./navidrome.nix
    # ./ldap.nix
    # ./home-assistant.nix
    # ./llama.nix
    # ./nextcloud.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
