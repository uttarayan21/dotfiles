{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu" || device.is "kuro" || device.is "shiro" || device.is "tako") [pkgs.deploy-rs.deploy-rs];
}
