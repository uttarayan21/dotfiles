{...}: {
  imports = [
    # ./ollama.nix
    # ./rsyncd.nix
    # ./sunshine.nix
    # ./zerotier.nix
    ./tailscale.nix
    ./samba.nix
    ./mullvad.nix
    ./openrgb.nix
  ];
  services = {
    # hardware.openrgb.enable = true;
  };
}
