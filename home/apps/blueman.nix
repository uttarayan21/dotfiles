{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.blueman
    pkgs.webcord
  ];
  # services.blueman.enable = true;
  services.blueman-applet.enable = true;
}
