{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {mpv = pkgs.mpv-unwrapped.override {sixelSupport = true;};};
  };
}
