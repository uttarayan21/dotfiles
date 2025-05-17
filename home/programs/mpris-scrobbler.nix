{pkgs, ...}: {
  home.packages = [
    pkgs.mpris-scrobbler
  ];
  # services.mpd = {
  #   enable = pkgs.stdenv.isLinux;
  # };
}
