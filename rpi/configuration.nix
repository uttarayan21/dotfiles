{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "xatu";
  networking.filrewall.logRefusedConnections = lib.mkDefault false;
  networking.useNetworkd = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
