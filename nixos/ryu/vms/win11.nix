{ config, pkgs, lib, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # IOMMU and VFIO settings
  boot.kernelParams = [
    "amd_iommu=on"  # Use "intel_iommu=on" for Intel CPUs
    "iommu=pt"
    "vfio-pci.ids=10de:2504,10de:228e"  # Replace with your GPU's vendor:device IDs
  ];

  boot.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "vfio_virqfd"
  ];

  # Early loading of VFIO
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "vfio_virqfd"
  ];

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
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = let
        win11xml = pkgs.writeText "win11.xml" ''
          <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
            <name>win11</name>
            <memory unit='GiB'>16</memory>
            <vcpu placement='static'>8</vcpu>
            <cpu mode='host-passthrough' check='none'>
              <topology sockets='1' dies='1' cores='4' threads='2'/>
              <feature policy='require' name='topoext'/>
            </cpu>
            <os>
              <type arch='x86_64' machine='pc-q35-8.0'>hvm</type>
              <loader readonly='yes' type='pflash'>/run/libvirt/nix-ovmf/OVMF_CODE.fd</loader>
              <nvram>/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
              <boot dev='hd'/>
              <boot dev='cdrom'/>
            </os>
            <features>
              <acpi/>
              <apic/>
              <hyperv mode='custom'>
                <relaxed state='on'/>
                <vapic state='on'/>
                <spinlocks state='on' retries='8191'/>
                <vendor_id state='on' value='123456789123'/>
              </hyperv>
              <vmport state='off'/>
            </features>
            <devices>
              <disk type='file' device='disk'>
                <driver name='qemu' type='qcow2' discard='unmap'/>
                <source file='/var/lib/libvirt/images/win11.qcow2'/>
                <target dev='vda' bus='virtio'/>
              </disk>
              <disk type='file' device='cdrom'>
                <driver name='qemu' type='raw'/>
                <source file='/var/lib/libvirt/images/Win11.iso'/>
                <target dev='sda' bus='sata'/>
                <readonly/>
              </disk>
              <disk type='file' device='cdrom'>
                <driver name='qemu' type='raw'/>
                <source file='/var/lib/libvirt/images/virtio-win.iso'/>
                <target dev='sdb' bus='sata'/>
                <readonly/>
              </disk>
              <interface type='bridge'>
                <source bridge='virbr0'/>
                <model type='virtio'/>
              </interface>
              <hostdev mode='subsystem' type='pci' managed='yes'>
                <source>
                  <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
                </source>
              </hostdev>
              <hostdev mode='subsystem' type='pci' managed='yes'>
                <source>
                  <address domain='0x0000' bus='0x01' slot='0x00' function='0x1'/>
                </source>
              </hostdev>
              <memballoon model='virtio'/>
            </devices>
            <qemu:commandline>
              <qemu:arg value='-cpu'/>
              <qemu:arg value='host,hv_time,kvm=off,hv_vendor_id=null'/>
              <qemu:arg value='-device'/>
              <qemu:arg value='ivshmem-plain,memdev=looking-glass'/>
              <qemu:arg value='-object'/>
              <qemu:arg value='memory-backend-file,id=looking-glass,share=on,mem-path=/dev/shm/looking-glass,size=32M'/>
            </qemu:commandline>
          </domain>
        '';
      in "${pkgs.libvirt}/bin/virsh define ${win11xml} && ${pkgs.libvirt}/bin/virsh start win11";
      ExecStop = "${pkgs.libvirt}/bin/virsh shutdown win11";
    };
    wantedBy = [ "multi-user.target" ];
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