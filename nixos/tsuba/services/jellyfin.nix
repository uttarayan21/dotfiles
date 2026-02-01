{
  pkgs,
  config,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      jellyfin = {
        image = "jellyfin/jellyfin:latest";
        ports = ["127.0.0.1:8096:8096"];
        volumes = ["/var/lib/jellyfin:/config" "/volumes/media:/media" "/volumes/media/.cache:/cache"];
        environment = {
          PUID = toString config.users.users.jellyfin.uid;
          PGID = toString config.users.groups.jellyfin.gid;
          TZ = config.time.timeZone;
        };
      };
    };
  };
  users.users.jellyfin = {
    isSystemUser = true;
    home = "/var/lib/jellyfin";
    createHome = true;
    group = "jellyfin";
  };
  users.extraUsers.jellyfin.extraGroups = ["media"];
  users.groups.jellyfin = {};

  services = {
    caddy = {
      virtualHosts."jellyfin.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:8096
      '';
      virtualHosts."jellyfin.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:8096
      '';
    };
  };
  systemd.services.jellyfin-image-update = {
    description = "Pull latest Jellyfin Docker image";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker pull jellyfin/jellyfin:latest";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-jellyfin.service";
    };
  };

  # Systemd timer to run the update service every 5 days
  systemd.timers.jellyfin-image-update = {
    description = "Timer for Jellyfin image updates";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon *-*-* 02:00:00";
      OnUnitInactiveSec = "5d";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
