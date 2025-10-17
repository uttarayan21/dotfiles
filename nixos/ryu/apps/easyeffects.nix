{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [easyeffects];
}
