{
  device,
  lib,
  ...
}:
lib.optionalAttrs (device.is "ryu" || device.is "kuro") {
  programs.opencode = {
    enable = true;
  };
}
