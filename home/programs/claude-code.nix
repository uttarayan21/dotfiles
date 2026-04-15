{device, ...}: {
  programs.claude-code.enable = !device.isServer;
}
