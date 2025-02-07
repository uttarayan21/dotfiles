{
  pkgs,
  device,
  xdg,
  ...
}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${device.user}";
    group = "${device.user}";
    dataDir = xdg.dataDirs.syncthing;
    configDir = xdg.configDirs.syncthing;
  };
}
