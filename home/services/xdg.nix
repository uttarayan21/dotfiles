{
  lib,
  device,
  ...
}:
{
  xdg = {
    portal = {
      enable = device.is "ryu";
      config = {
        hyprland.default = ["hyprland"];
        common.default = ["*" "hyprland"];
      };
    };
  };
}
// lib.optionalAttrs (device.is "ryu" || device.is "tako") {
  xdg.userDirs.setSessionVariables = true;
}
