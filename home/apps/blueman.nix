{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.blueman
  ];
  services.blueman-applet.enable = pkgs.stdenv.isLinux;
}
