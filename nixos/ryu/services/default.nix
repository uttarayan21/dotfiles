{...}: {
  imports = [
    # ./ollama.nix
    # ./rsyncd.nix
    # ./sunshine.nix
    # ./zerotier.nix
    # ./dnscrypt.nix
    ./tailscale.nix
    ./samba.nix
    ./mullvad.nix
    ./openrgb.nix
    ./command-runner.nix
    ./resolved.nix
    ./minecraft.nix
  ];
  services = {
    # hardware.openrgb.enable = true;
  };
}
