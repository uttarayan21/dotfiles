{...}: {
  imports = [
    # ./rsyncd.nix
    # ./sunshine.nix
    # ./zerotier.nix
    # ./dnscrypt.nix
    ./llama.nix
    ./ollama.nix
    ./tailscale.nix
    ./samba.nix
    ./mullvad.nix
    ./openrgb.nix
    ./command-runner.nix
    ./resolved.nix
    ./minecraft.nix
    ./fwupd.nix
    ./caddy.nix
    ./monitoring.nix
    ./wivrn.nix
    ./sshd.nix
    ./fprintd.nix
    ./handoff.nix
    ./gstreamer.nix
    ./dualsense.nix
    ./openssh.nix
  ];
}
