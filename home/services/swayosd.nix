{device, ...}: {
  services.swayosd.enable = device.name == "ryu";
}
