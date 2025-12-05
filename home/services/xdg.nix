{
  pkgs,
  lib,
  device,
  ...
}:
lib.optionalAttrs (device.is "ryu") {
  xdg.portal = {
    enable = pkgs.stdenv.isLinux;
    config = {
      hyprland.default = ["kde" "hyprland"];
      common.default = ["*" "hyprland"];
    };
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
