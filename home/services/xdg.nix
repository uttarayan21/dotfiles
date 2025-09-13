{pkgs, ...}: {
  xdg.portal = {
    enable = pkgs.stdenv.isLinux;
    # config = {
    #
    # };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
