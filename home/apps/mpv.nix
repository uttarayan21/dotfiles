{pkgs, ...}: {
  programs.mpv = {
    enable = pkgs.stdenv.isLinux;
    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      target-colorspace-hint = "auto";
      cache = "yes";
      demuxer-max-bytes = "1024MiB";
      demuxer-max-back-bytes = "256MiB";
      hwdec = "auto";
      loop-file = "inf";
      loop-playlist = "inf";
    };
    profiles = {
      HDR = {
        profile-cond = ''p["video-params/primaries"] == "bt.2020"'';
        hdr-compute-peak = "yes";
        hdr-peak-percentile = 99.8;
        hdr-peak-decay-rate = 20;
        hdr-contrast-recovery = 0.5;
        target-peak = 400;
        tone-mapping = "spline";
        target-trc = "pq";
        target-contrast = 2500;
      };
      SDR = {
        profile-cond = ''p["video-params/primaries"] and p["video-params/primaries"] ~= "bt.2020"'';
        inverse-tone-mapping = "yes";
        target-peak = 203;
        tone-mapping = "auto";
        target-trc = "auto";
        target-contrast = "auto";
      };
    };
  };
}
