{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.homeassistant or {};
in {
  config = mkIf (cfg.enable or false) {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:latest";
        volumes = [
          "/var/lib/homeassistant:/config"
          "/etc/localtime:/etc/localtime:ro"
          "/run/dbus:/run/dbus:ro"
        ];
        privileged = true;
        extraOptions = ["--network=host"];
        environment = {
          PUID = toString config.users.users.homeassistant.uid;
          PGID = toString config.users.groups.homeassistant.gid;
          TZ = config.time.timeZone;
        };
      };
    };

    users.users.homeassistant = {
      isSystemUser = true;
      home = "/var/lib/homeassistant";
      createHome = true;
      group = "homeassistant";
    };
    users.groups.homeassistant = {};

    systemd.services.homeassistant-image-update = {
      description = "Pull latest Home Assistant Docker image";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.docker}/bin/docker pull ghcr.io/home-assistant/home-assistant:latest";
        ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-homeassistant.service";
      };
    };

    systemd.timers.homeassistant-image-update = {
      description = "Timer for Home Assistant image updates";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "Mon *-*-* 02:00:00";
        OnUnitInactiveSec = "5d";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
