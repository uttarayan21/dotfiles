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
    ./command-runner.nix
  ];
  services = {
    # hardware.openrgb.enable = true;
  };
}
