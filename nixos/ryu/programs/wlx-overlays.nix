{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wlx-overlay-s
  ];
}
