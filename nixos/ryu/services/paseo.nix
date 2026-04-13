{device, ...}: {
  services.paseo = {
    enable = true;
    user = device.user;
  };
}
