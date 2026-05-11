{
  device,
  lib,
  ...
}:
{
  imports = [./nvf];

  programs.nvf.enable =
    device.is "ryu"
    || device.is "kuro"
    || device.is "mirai"
    || device.is "tako"
    || device.is "shiro";
}
// lib.optionalAttrs (!(device.is "tsuba")) {
  stylix.targets.nvf.enable = false;
}
