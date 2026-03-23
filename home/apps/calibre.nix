{device, ...}: {
  programs.calibre.enable = device.is "ryu";
}
