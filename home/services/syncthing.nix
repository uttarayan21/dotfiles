{
  pkgs,
  device,
  config,
  ...
}: {
  services.syncthing = {
    enable = device.is "ryu";
    openDefaultPorts = true;
    # user = "${device.user}";
    # group = "${device.user}";
    # dataDir = "${config.home.homeDirectory}/Sync";
    # configDir = "${config.xdg.configHome}/syncthing";
  };
}
