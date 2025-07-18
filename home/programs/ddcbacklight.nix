{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = lib.optionals (device.name == "ryu") [pkgs.ddcbacklight];
}
