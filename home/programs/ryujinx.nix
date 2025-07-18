{
  lib,
  pkgs,
  device,
  ...
}: {
  home.packages = lib.optionals (device.name == "ryu") [
    pkgs.ryujinx
  ];
}
