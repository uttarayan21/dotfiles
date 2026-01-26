{
  pkgs,
  lib,
  device,
  ...
}: {
  xdg.portal = {
    enable = true;
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
