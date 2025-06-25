{
  config,
  pkgs,
  lib,
  ...
}: {
  # networking.hostName = "tsuba";
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

  hardware.raspberry-pi.config = {
    dtparam = "audio=on";
    camera_auto_detect = 0;
    display_auto_detect = 0;
    auto_initramfs = 1;
    disable_fw_kms_setup = 1;
    arm_boost = 1;
    arm_64bit = 1;
    all = {
      usb_max_current_enable = 1;
    };
  };
}
