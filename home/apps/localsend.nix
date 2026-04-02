{
  pkgs,
  lib,
  device,
  ...
}:
lib.optionalAttrs (device.is "kuro" || device.is "shiro") {
  home.packages = [
    pkgs.localsend
  ];
}
