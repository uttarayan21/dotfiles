{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    # pkgs.jellyflix
    # pkgs.jellyfin-media-player
    pkgs.jellyfin-mpv-shim
    pkgs.jellytui
  ];
}
