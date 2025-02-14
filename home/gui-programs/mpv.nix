{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.mpv-unwrapped.wrapper {mpv = pkgs.mpv-unwrapped.override {sixelSupport = true;};}
      else pkgs.mpv;
  };
}
