{config, ...}: {
  services = {
    hardware.openrgb.enable = true;
  };
  networking.firewall.allowedTCPPorts = [config.services.hardware.openrgb.server.port];
}
