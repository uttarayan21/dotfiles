{pkgs, ...}: {
  environment.systemPackages = with pkgs; [nvtopPackages.nvidia];
}
