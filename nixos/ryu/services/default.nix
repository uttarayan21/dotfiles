{...}: {
  imports = [
    # ./rsyncd.nix
    # ./zerotier.nix
    # ./dnscrypt.nix
    ./caddy.nix
    ./dualsense.nix
    ./fprintd.nix
    ./fwupd.nix
    ./gstreamer.nix
    ./handoff.nix
    ./minecraft.nix
    ./monitoring.nix
    ./mullvad.nix
    ./ollama.nix
    ./openrgb.nix
    ./openssh.nix
    ./resolved.nix
    ./samba.nix
    ./sshd.nix
    # ./sunshine.nix
    ./tailscale.nix
    ./wivrn.nix
    ./pipewire.nix
  ];
}
