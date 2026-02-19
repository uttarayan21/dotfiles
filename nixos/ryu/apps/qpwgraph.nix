{pkgs, ...}: {
  environment.systemPackages = with pkgs; [qpwgraph];
}
