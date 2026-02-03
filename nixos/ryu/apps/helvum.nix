{pkgs, ...}: {
  environment.systemPackages = with pkgs; [helvum];
}
