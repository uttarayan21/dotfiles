{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      # hdr-compute-peak = "yes";
      # hdr-peak-detect = "yes";
      # target-peak = 400;
      # target-prim = "bt.2020";
      # target-trc = "pq";
      # inverse-tone-mapping = "yes";
      # tone-mapping = "spline";
      # tone-mapping-mode = "auto";
      # target-colorspace-hint = "auto";
      # gamut-mapping = "desaturate";
    };
    package =
      if pkgs.stdenv.isLinux
      then pkgs.mpv-unwrapped.wrapper {mpv = pkgs.mpv-unwrapped.override {sixelSupport = true;};}
      else pkgs.mpv;
  };
}
