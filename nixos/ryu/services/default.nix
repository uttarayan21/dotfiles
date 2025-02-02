{...}: {
  imports = [
    ./samba.nix
    ./sunshine.nix
  ];
  services = {
    hardware.openrgb.enable = true;
    tailscale = {
      enable = true;
    };
    mullvad-vpn.enable = true;
  };
}
