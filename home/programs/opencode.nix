{
  device,
  lib,
  ...
}:
lib.optionalAttrs (device.is "ryu") {
  programs.opencode = {
    enable = true;
  };
}
