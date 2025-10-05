{
  pkgs,
  lib,
  ...
}: {
  services.nextcloud-client = {
    enable = pkgs.stdenv.isLinux;
    startInBackground = true;
  };
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.nextcloud-client
  ];
}
