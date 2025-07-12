{
  config,
  lib,
  ...
}: let
  firmwarePartition = lib.recursiveUpdate {
    # label = "FIRMWARE";
    priority = 1;

    type = "0700"; # Microsoft basic data
    # attributes = [
    #   0 # Required Partition
    # ];

    size = "1024M";
    content = {
      type = "filesystem";
      format = "vfat";
      # mountpoint = "/boot/firmware";
      mountOptions = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
  };

  espPartition = lib.recursiveUpdate {
    # label = "ESP";

    type = "EF00"; # EFI System Partition (ESP)
    # attributes = [
    #   2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
    # ];

    size = "1024M";
    content = {
      type = "filesystem";
      format = "vfat";
      # mountpoint = "/boot";
      mountOptions = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
        "umask=0077"
      ];
    };
  };
in {
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            FIRMWARE = firmwarePartition {
              label = "FIRMWARE";
              content.mountpoint = "/boot/firmware";
            };
            ESP = espPartition {
              label = "ESP";
              content.mountpoint = "/boot";
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
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "64G";
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
          nix = {
            size = "256G";
            lvm_type = "raid0";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          };
          home = {
            size = "256G";
            lvm_type = "raid0";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
          media = {
            size = "100%";
            lvm_type = "raid0";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/volumes/media";
            };
          };
        };
      };
    };
  };
}
