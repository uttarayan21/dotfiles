{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    polychromatic
    openrazer-daemon
  ];
}
