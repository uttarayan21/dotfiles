{pkgs, ...}: {
  programs.obs-studio = {
    enable = pkgs.stdenv.isLinux;
    # enableVirtualCamera = true;
    plugins = [
      pkgs.obs-studio-plugins.wlrobs
      pkgs.obs-studio-plugins.droidcam-obs
    ];
  };
}
