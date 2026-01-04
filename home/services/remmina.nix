{device, ...}: {
  services.remmina = {
    enable = device.is "ryu";
    systemdService.enable = true;
    addRdpMimeTypeAssoc = true;
  };
}
