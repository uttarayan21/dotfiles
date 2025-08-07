{
  lib,
  device,
  pkgs,
  ...
}:
lib.mkIf (device.is "ryu") {
  home.packages = with pkgs; [
    lmstudio
  ];
}
