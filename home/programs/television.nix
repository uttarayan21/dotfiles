{device, ...}: {
  programs.television.enable = !device.isServer;
}
