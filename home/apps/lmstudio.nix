{
  lib,
  device,
  pkgs,
  ...
}:
lib.optionalAttrs device.hasGui {
  home.packages = with pkgs; [
    lmstudio
  ];
}
