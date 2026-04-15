{device, ...}: {
  programs.uv.enable = !device.isServer;
}
