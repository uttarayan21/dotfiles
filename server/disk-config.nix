{lib, ...}: {
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            # esp = {
            #   size = "1G";
            #   type = "EF00";
            #   content = {
            #     type = "mdraid";
            #     name = "boot";
            #   };
            # };
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    # mdadm = {
    #   esp = {
    #     type = "mdadm";
    #     level = 1;
    #     metadata = "1.0";
    #     content = {
    #       type = "filesystem";
    #       format = "vfat";
    #       mountpoint = "/boot";
    #     };
    #   };
    # };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "128G";
            lvm_type = "mirror";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "512G";
            lvm_type = "raid0";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}
