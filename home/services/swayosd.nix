{device, ...}: {
  services.swayosd.enable = device.is "ryu";
}
