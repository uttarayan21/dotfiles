{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    # config = {
    #
    # };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
