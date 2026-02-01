{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = lib.optionals (device.name != "shiro") [pkgs.blobdrop];
}
