{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = lib.mkIf (device.is "ryu") [
    pkgs.rustdesk
  ];
}
