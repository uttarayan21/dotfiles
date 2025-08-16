{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = lib.mkIf (device.is "ryu") [
    pkgs.orca-slicer
  ];
}
