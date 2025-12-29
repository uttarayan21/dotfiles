{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets."pihole/password" = {};
    templates."pihole.env".content = ''
      FTLCONF_webserver_api_password=${config.sops.placeholder."pihole/password"}
    '';
  };
  virtualisation.oci-containers = {
    containers = {
      pihole = {
        image = "pihole/pihole:latest";
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "127.0.0.1:8053:80/tcp"
        ];
        privileged = true;
        environment = {
          TZ = config.time.timeZone;
          FTLCONF_dns_listeningMode = "ALL";
        };
        environmentFiles = [
          config.sops.templates."pihole.env".path
        ];
        volumes = [
          "/etc/pihole:/etc/pihole"
        ];
        capabilities = {
          "NET_ADMIN" = true;
          "SYS_TIME" = true;
          "SYS_NICE" = true;
        };
      };
    };
  };

  services.caddy = {
    virtualHosts."pihole.darksailor.dev".extraConfig = ''
      import cloudflare
      redir / /admin permanent
      reverse_proxy localhost:8053
    '';
  };

  # Systemd service to pull latest Home Assistant image
  systemd.services.pihole-image-update = {
    description = "Pull latest Pi Hole Docker image";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker pull pihole/pihole:latest";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-pihole.service";
    };
  };

  # Systemd timer to run the update service every 5 days
  systemd.timers.pihole-image-update = {
    description = "Timer for Pi-Hole image updates";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon *-*-* 02:00:00";
      OnUnitInactiveSec = "5d";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
