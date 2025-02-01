{...}: {
  imports = [
    ./samba.nix
    ./sunshine.nix
  ];
  services = {
    tailscale = {
      enable = true;
    };
    mullvad-vpn.enable = true;
  };
}
