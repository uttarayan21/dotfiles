{
  pkgs,
  lib,
  device,
  ...
}: {
  xdg.portal = {
    enable = device.is "ryu";
    config = {
      hyprland.default = ["hyprland"];
      common.default = ["*" "hyprland"];
    };
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
