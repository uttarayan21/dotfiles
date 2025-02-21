{...}: {
  imports = [
    ./samba.nix
    ./sunshine.nix
    ./ollama.nix
    ./rsyncd.nix
  ];
  services = {
    hardware.openrgb.enable = true;
    tailscale = {
      enable = true;
    };
    mullvad-vpn.enable = true;
  };
}
