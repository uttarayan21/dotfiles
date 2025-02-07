{
  pkgs,
  device,
  config,
  ...
}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    # user = "${device.user}";
    # group = "${device.user}";
    # dataDir = "${config.home.homeDirectory}/Sync";
    # configDir = "${config.xdg.configHome}/syncthing";
  };
}
