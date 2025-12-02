{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = with pkgs; lib.optionals (device.is "ryu") [gimp];
}
