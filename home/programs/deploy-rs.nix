{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu") [pkgs.deploy-rs.deploy-rs];
}
