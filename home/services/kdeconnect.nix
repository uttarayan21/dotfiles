{device, ...}: {
  services.kdeconnect.enable = device.is "ryu";
  services.kdeconnect.indicator = device.is "ryu";
}
