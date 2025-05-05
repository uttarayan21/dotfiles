{...}: {
  imports = [
    ./samba.nix
    ./sunshine.nix
    ./ollama.nix
    ./rsyncd.nix
    ./tailscale.nix
    ./zerotier.nix
  ];
  services = {
    hardware.openrgb.enable = true;
    mullvad-vpn.enable = true;
  };
}
