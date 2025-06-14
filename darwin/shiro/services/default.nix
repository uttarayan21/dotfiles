{...}: {
  imports = [
    ./yabai.nix
    ./skhd.nix
    ./tailscale.nix
    ./zerotier.nix
    ./jellyfin.nix
    ./autossh.nix
    # ./homeassistant.nix
    # ./aerospace.nix
  ];
}
