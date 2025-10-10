{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu" || device.is "kuro") [
    pkgs.xh
  ];
}
