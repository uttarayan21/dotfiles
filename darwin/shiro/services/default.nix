{...}: {
  imports = [
    # ../../../modules/darwin/caddy
    ./yabai.nix
    ./skhd.nix
    ./tailscale.nix
    ./autossh.nix
    # ./caddy.nix
    ./sops.nix
    # ./lmstudio.nix
    # ./colima.nix
    # ./zerotier.nix
    # ./aerospace.nix
  ];
}
