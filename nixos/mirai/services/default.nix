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
    # ./appflowy.nix
    # ./home-assistant.nix

    # ./jellyfin.nix
    # ./polaris.nix
    ./seafile.nix
    # ./syncthing.nix
    # ./vscode.nix
    # ./nextcloud.nix
    # ./navidrome.nix
    # ./ldap.nix
    # ./llama.nix
    # ./nextcloud.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
  };
}
