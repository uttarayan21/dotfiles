{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xhost
  ];
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      # package = pkgs.hyprland;
      # portalPackage = pkgs.xdph;
    };
    uwsm.enable = true;
  };
}
