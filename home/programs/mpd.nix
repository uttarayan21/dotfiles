{pkgs, ...}: {
  services.mpd = {
    enable = pkgs.stdenv.isLinux;
  };
}
