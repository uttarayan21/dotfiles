{
  pkgs,
  lib,
  device,
  inputs,
  ...
}: {
  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
  xdg.portal = {
    enable = device.is "ryu";
    config = {
      hyprland.default = ["hyprland"];
      common.default = ["*" "hyprland"];
    };
  };
}
