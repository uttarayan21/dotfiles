{
  pkgs,
  lib,
  device,
  ...
}: {
  home.packages = with pkgs;
    lib.mkIf (device.is "ryu") [
      bluetui
    ];
}
