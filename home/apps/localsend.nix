{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.mkIf (device.is "kuro" || device.is "shiro") [
    pkgs.localsend
  ];
}
