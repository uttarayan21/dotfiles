{
  lib,
  config,
  device,
  ...
}: {
  # networking.firewall.allowPing = true;
  sops = {
    secrets."nas/password" = {};
    templates."nas-credentials".content = ''
      username=${device.user}
      domain=WORKGROUP
      password=${config.sops.placeholder."nas/password"}
    '';
  };
  fileSystems."/volumes/nas" = {
    device = "//tsuba.darksailor.dev/nas";
    fsType = "cifs";

    options = let
      options = "nofail,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      uid = toString config.users.users.servius.uid;
      gid = toString config.users.groups.servius.gid;
      check = lib.asserts.assertMsg (
        uid != "" && gid != ""
      ) "User ${device.user} must have uid ang gid set to mount NAS as user.";
    in
      lib.optionals check ["${options},credentials=${config.sops.templates."nas-credentials".path},uid=${uid},gid=${gid}"];
  };
}
