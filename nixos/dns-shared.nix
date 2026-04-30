{inputs, ...}: {
  networking.domains = {
    enable = true;
    defaultTTL = 3600;
    baseDomains."darksailor.dev".a.data = inputs.self.devices.tako.externalIp;
  };
}
