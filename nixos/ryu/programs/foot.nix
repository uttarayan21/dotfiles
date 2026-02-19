{pkgs, ...}: {
  environment.systemPackages = with pkgs; [foot];
}
