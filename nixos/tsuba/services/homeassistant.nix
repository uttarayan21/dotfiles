{
  pkgs,
  lib,
  config,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:latest";
        volumes = [
          "/var/lib/homeassistant:/config"
          "/etc/localtime:/etc/localtime:ro"
          "/run/dbus:/run/dbus:ro"
        ];
        privileged = true;
        extraOptions = [
          "--network=host"
        ];
        environment = {
          PUID = toString config.users.users.homeassistant.uid;
          PGID = toString config.users.groups.homeassistant.gid;
          TZ = config.time.timeZone;
        };
      };
    };
  };
  users.users.homeassistant = {
    isSystemUser = true;
    home = "/var/lib/homeassistant";
    createHome = true;
    group = "homeassistant";
  };
  users.extraUsers.homeassistant.extraGroups = ["media"];
  users.groups.homeassistant = {};

  services.caddy = {
    virtualHosts."home.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:8123
    '';
  };

  # Systemd service to pull latest Home Assistant image
  systemd.services.homeassistant-image-update = {
    description = "Pull latest Home Assistant Docker image";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker pull ghcr.io/home-assistant/home-assistant:latest";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-homeassistant.service";
    };
  };

  # Systemd timer to run the update service every 5 days
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
}
