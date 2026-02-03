{pkgs, ...}: {
  environment.systemPackages = with pkgs; [mixid];
  services.udev.packages = with pkgs; [mixid];
}
