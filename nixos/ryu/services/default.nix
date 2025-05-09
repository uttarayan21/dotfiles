{...}: {
  imports = [
    # ./sunshine.nix
    # ./ollama.nix
    # ./rsyncd.nix
    ./samba.nix
    ./tailscale.nix
    # ./zerotier.nix
  ];
  services = {
    # hardware.openrgb.enable = true;
    mullvad-vpn.enable = true;
  };
}
