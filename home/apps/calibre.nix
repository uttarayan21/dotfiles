{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu") [pkgs.calibre];
}
