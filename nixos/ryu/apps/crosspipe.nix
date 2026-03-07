{pkgs, ...}: {
  environment.systemPackages = with pkgs; [crosspipe];
}
