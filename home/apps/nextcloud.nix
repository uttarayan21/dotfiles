{
  pkgs,
  lib,
  ...
}: {
  services.nextcloud-client = {
    enable = pkgs.stdenv.isLinux;
    startInBackground = true;
  };
}
