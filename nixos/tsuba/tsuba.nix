{
  config,
  pkgs,
  device,
  lib,
  ...
}: {
  networking.hostName = device.name;
  networking.firewall.logRefusedConnections = lib.mkDefault false;
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

  # hardware.raspberry-pi.config = {
  #   all = {
  #     "dtparam" = [
  #       "pciex1"
  #       "pciex1_gen=2"
  #     ];
  #   };
  # };
  # hardware.raspberry-pi.extra-config = ''
  #   [all]
  #   dtparam=pciex1
  #   dtparam=pciex1_gen=2
  # '';
}
# ({
#   config,
#   pkgs,
#   lib,
#   ...
# }: {
#
#   system.nixos.tags = let
#     cfg = config.boot.loader.raspberryPi;
#   in [
#     "raspberry-pi-${cfg.variant}"
#     cfg.bootloader
#     config.boot.kernelPackages.kernel.version
#   ];
#   # hardware.raspberry-pi.config = {
#   # };
#   system.stateVersion = "25.05";
#   services.openssh.enable = true;
# })

