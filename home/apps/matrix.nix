{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu") [
    pkgs.fluffychat
    pkgs.element-desktop
    # pkgs.quaternion
  ];
}
