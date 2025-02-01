{
  config,
  lib,
  pkgs,
  nixvirt,
}: let
  ids = ["10de:2783" "10de:22bc"];
in {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
    libvirt = {
      swtpm.enable = true;
      connections."qemu:///mouldy".domains = [
        {
          definition = nixvirt.lib.domain.writeXML (nixvirt.lib.domain.templates.windows
            {
              name = "Mouldy";
              uuid = "eb9fbbf8-de07-4458-81dd-ed914f856e2a";
              memory = {
                count = 32;
                unit = "GiB";
              };
              # storage_vol = {
              #   pool = "MyPool";
              #   volume = ".qcow2";
              # };
              install_vol = /home/servius/vms/windows/Win11_24H2_English_x64.iso;
              nvram_path = /home/servius/vms/windows/Mouldy.nvram;
              virtio_net = true;
              virtio_drive = true;
              install_virtio = true;
            });
        }
      ];
    };
  };
  users.extraUsers.servius.extraGroups = ["libvirtd" "kvm"];
  boot.kernelParams = [("vfio-pci.ids" + lib.concatStringsSep "," ids)];
}
