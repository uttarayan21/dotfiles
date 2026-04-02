{...}: {
  imports = [
    # ./calibre.nix
    # ./dnscrypt.nix
    # ./rsyncd.nix
    # ./sunshine.nix
    # ./zerotier.nix

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
    ./pipewire.nix
    ./resolved.nix
    ./samba.nix
    ./sshd.nix
    ./tailscale.nix
    # ./vllm.nix
    ./wivrn.nix
  ];
}
