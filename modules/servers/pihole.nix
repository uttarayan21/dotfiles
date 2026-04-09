{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.pihole or {};
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."pihole/password" = {};
      templates."pihole.env".content = ''
        FTLCONF_webserver_api_password=${config.sops.placeholder."pihole/password"}
      '';
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.pihole = {
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
        environmentFiles = [config.sops.templates."pihole.env".path];
        volumes = ["/etc/pihole:/etc/pihole"];
        capabilities = {
          "NET_ADMIN" = true;
          "SYS_TIME" = true;
          "SYS_NICE" = true;
        };
      };
    };

    systemd.services.pihole-image-update = {
      description = "Pull latest Pi-hole Docker image";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.docker}/bin/docker pull pihole/pihole:latest";
        ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-pihole.service";
      };
    };

    systemd.timers.pihole-image-update = {
      description = "Timer for Pi-hole image updates";
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
