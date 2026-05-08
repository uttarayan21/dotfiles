{inputs, ...}: {
  networking.domains = {
    enable = true;
    defaultTTL = 300;
    baseDomains."darksailor.dev".a.data = inputs.self.devices.tako.externalIp;
    subDomains."lmstudio.shiro.darksailor.dev".a.data = "100.80.149.119";
  };
}
