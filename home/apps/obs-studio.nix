{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    # enableVirtualCamera = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
