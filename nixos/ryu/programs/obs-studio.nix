{pkgs, ...}: {
  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
        pkgs.obs-studio-plugins.droidcam-obs
      ];
    };
  };
}
