{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-rs
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gst_all_1.gstreamermm
      gst_all_1.gst-rtsp-server
      gst_all_1.gst-vaapi
      # gst_all_1.icamerasrc-ipu6
      # gst_all_1.icamerasrc-ipu6ep
      # gst_all_1.icamerasrc-ipu6epmtl
    ];
    sessionVariables = {
      GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
    };
  };
}
