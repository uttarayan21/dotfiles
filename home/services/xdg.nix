{
  pkgs,
  lib,
  device,
  inputs,
  ...
}: {
  xdg = {
    portal = {
      enable = device.is "ryu";
      config = {
        hyprland.default = ["hyprland"];
        common.default = ["*" "hyprland"];
      };
    };
    userDirs.setSessionVariables = true;
  };
}
# // lib.optionalAttrs (device.is "ryu") {
#   environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
# }

