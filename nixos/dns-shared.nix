{inputs, ...}: {
  networking.domains = {
    enable = true;
    defaultTTL = 300;
    baseDomains."darksailor.dev".a.data = inputs.self.devices.tako.externalIp;
  };
}
