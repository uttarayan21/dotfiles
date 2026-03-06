{
  pkgs,
  lib,
  device,
  inputs,
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
      # xdg-desktop-portal-hyprland
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
