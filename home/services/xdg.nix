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
      hyprland.default = ["hyprland" "kde"];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
