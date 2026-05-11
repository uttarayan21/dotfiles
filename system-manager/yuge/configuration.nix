{...}: {
  imports = [
    ./moonlight.nix
    ./recover.nix
    ./shadps4.nix
    ./sshd.nix
    ./sudo.nix
    ./tailscale.nix
    ./fish.nix
  ];

  system-manager.allowAnyDistro = true;
}
