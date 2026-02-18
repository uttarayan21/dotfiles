{pkgs, ...}: {
  programs.mpv = {
    enable = pkgs.stdenv.isLinux;
    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      loop-file = "inf";
      loop-playlist = "inf";
    };
    profiles = {
      # hdr = {
      #   vo = "gpu-next";
      #   gpu-api = "vulkan";
      #   hdr-compute-peak = "yes";
      #   hdr-peak-detect = "yes";
      #   target-peak = 400;
      #   target-prim = "bt.2020";
      #   target-trc = "pq";
      #   inverse-tone-mapping = "yes";
      #   tone-mapping = "spline";
      #   tone-mapping-mode = "auto";
      #   target-colorspace-hint = "auto";
      #   gamut-mapping = "desaturate";
      # };
    };
  };
}
