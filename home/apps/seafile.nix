{
  pkgs,
  lib,
  ...
}: {
  home.packages =
    /*
    lib.optionals pkgs.stdenv.isLinux
    */
    [
      pkgs.seafile-client
    ];
}
