{pkgs, ...}: {
  programs.obs-studio = {
    enable = pkgs.stdenv.isLinux;
    # enableVirtualCamera = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
