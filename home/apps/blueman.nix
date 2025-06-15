{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.blueman
    pkgs.webcord
  ];
  services.blueman-applet.enable = pkgs.stdenv.isLinux;
}
