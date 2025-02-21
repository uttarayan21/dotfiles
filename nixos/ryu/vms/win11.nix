{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # IOMMU and VFIO settings
  # boot.kernelParams = [
  #   "amd_iommu=on" # Use "intel_iommu=on" for Intel CPUs
  #   "iommu=pt"
  #   "vfio-pci.ids=10de:2504,10de:228e" # Replace with your GPU's vendor:device IDs
  # ];

  # boot.kernelModules = [
  #   "vfio_pci"
  #   "vfio"
  #   "vfio_iommu_type1"
  #   "vfio_virqfd"
  # ];
  #
  # # Early loading of VFIO
  # boot.initrd.kernelModules = [
  #   "vfio_pci"
  #   "vfio"
  #   "vfio_iommu_type1"
  #   "vfio_virqfd"
  # ];

  # Define the Windows 11 VM
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    user = "root"
    group = "root"
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc","/dev/hpet"
    ]
  '';

  virtualisation.libvirtd.hooks.qemu = {
    "win11" = ''
      # Add any VM hooks here if needed
    '';
  };

  systemd.services.libvirtd-win11 = {
    description = "Windows 11 VM";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.libvirt}/bin/virsh define ${./windows.xml} && ${pkgs.libvirt}/bin/virsh start win11";
      ExecStop = "${pkgs.libvirt}/bin/virsh shutdown win11";
    };
    wantedBy = ["multi-user.target"];
  };

  # Setup Looking Glass shared memory
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 root qemu-libvirtd 32M"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    OVMF
    swtpm
    win-virtio
    looking-glass-client
  ];

  # Networking for VM
  networking.bridges.virbr0.interfaces = [];
  networking.interfaces.virbr0.useDHCP = true;

  # Enable huge pages for better performance
  boot.kernel.sysctl."vm.nr_hugepages" = 8192;

  # Optional: Enable looking glass for low-latency VM display
}

