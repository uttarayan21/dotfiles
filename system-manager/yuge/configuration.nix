{...}: {
  imports = [
    ./moonlight.nix
    ./recover.nix
    ./shadps4.nix
    ./sshd.nix
    ./sudo.nix
    ./tailscale.nix
  ];

  system-manager.allowAnyDistro = true;
}
