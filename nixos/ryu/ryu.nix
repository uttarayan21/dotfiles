# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # ./disk-config.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [pkgs.intel-compute-runtime pkgs.nvidia-vaapi-driver];
  };

  virtualisation.libvirtd.enable = true;
  users.extraUsers.servius.extraGroups = ["libvirtd" "adbusers" "kvm"];

  # options nvidia_drm modeset=1 fbdev=1
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
  services.fprintd.enable = true;
  services.sshd.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # hardware.bluetooth.settings = {

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm"];
  boot.kernelModules = [
    # "vfio_pci"
    # "vfio"

    "kvm-intel"
    "i2c-dev"
  ];
  boot.extraModulePackages = [];
  boot.kernelParams = ["intel_iommu=on"];
  # services.udev.packages = [pkgs.yubikey-personalization pkgs.yubikey-personalization-gui pkgs.via];
  services.udev.packages = [pkgs.via];
  services.yubikey-agent.enable = true;
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11d8beef-2a63-4231-af35-b9b8d3a17e9b";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/64099f91-d4d6-44fa-92d4-9e905b3e7829";
    fsType = "ext4";
    neededForBoot = true;
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4E27-DAC0";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d0835bd2-62fd-48d3-a0d1-8ae659f2e727";
    fsType = "ext4";
  };

  fileSystems."/media" = {
    device = "/dev/storage/media";
    fsType = "ext4";
    options = ["users" "nofail"];
  };

  fileSystems."/games" = {
    device = "/dev/storage/games";
    fsType = "ext4";
    options = ["users" "nofail"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
