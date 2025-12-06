{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu") [
    pkgs.ida-free
  ];
}
