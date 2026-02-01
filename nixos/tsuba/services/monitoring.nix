{
  pkgs,
  config,
  ...
}: let
  # Port configurations
  ports = {
    # System exporters
    node = 9100;
    systemd = 9558;
    process = 9256;

    # Infrastructure exporters
    cadvisor = 8080;
    caddy = 2019;

    # Media exporters
    jellyfin = 9220;
    pihole = 9617;

    # Servarr exporters (via exportarr)
    sonarr = 9707;
    radarr = 9708;
    lidarr = 9709;
    bazarr = 9710;

    # Torrent
    deluge = 9354;
  };
in {
  sops.secrets."pihole/password" = {};
  services = {
    prometheus = {
      exporters = {
        systemd = {
          enable = true;
          port = ports.systemd;
        };
        node = {
          enable = true;
          enabledCollectors = [
            "systemd"
            "textfile"
            "filesystem"
            "loadavg"
            "meminfo"
            "netdev"
            "stat"
            "time"
            "uname"
            "vmstat"
            "diskstats"
            "cpu"
          ];
          port = ports.node;
        };
        process = {
          enable = true;
          settings.process_names = [
            {
              name = "{{.Comm}}";
              cmdline = [".*"];
            }
          ];
        };
      };
    };
  };

  # Docker cAdvisor for container metrics
  virtualisation.oci-containers.containers.cadvisor = {
    image = "gcr.io/cadvisor/cadvisor:v0.49.1";
    ports = ["${toString ports.cadvisor}:8080"];
    volumes = [
      "/:/rootfs:ro"
      "/var/run:/var/run:ro"
      "/sys:/sys:ro"
      "/var/lib/docker/:/var/lib/docker:ro"
      "/dev/disk/:/dev/disk:ro"
    ];
    extraOptions = [
      "--privileged"
      "--device=/dev/kmsg"
    ];
  };

  # Jellyfin - use built-in metrics endpoint at http://localhost:8096/metrics
  # No separate exporter needed - Prometheus will scrape directly

  # Home Assistant - has built-in Prometheus integration
  # Configure in Home Assistant configuration.yaml:
  # prometheus:
  #   namespace: homeassistant

  # Pi-hole exporter
  # Uses sops-managed API token for authentication with Pi-hole v6
  # To set the token: edit secrets/secrets.yaml and replace the placeholder at pihole.api_token
  systemd.services.pihole-exporter = {
    description = "Pi-hole Prometheus Exporter";
    wantedBy = ["multi-user.target"];
    after = ["network.target" "sops-nix.service"];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      # Load API token from sops secret file
      LoadCredential = "ppassword:${config.sops.secrets."pihole/password".path}";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          -pihole_hostname localhost \
          -pihole_port 8053 \
          -port ${toString ports.pihole} \
          -pihole_password $(cat ''${CREDENTIALS_DIRECTORY}/ppassword)'
      '';
      Restart = "on-failure";
    };
  };

  # Exportarr for Sonarr
  # Disabled: needs API key configuration
  # systemd.services.exportarr-sonarr = {
  #   description = "Exportarr Prometheus Exporter for Sonarr";
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     DynamicUser = true;
  #     ExecStart = "${pkgs.exportarr}/bin/exportarr sonarr --port ${toString ports.sonarr} --url http://localhost:8989";
  #     Restart = "on-failure";
  #   };
  # };

  # Exportarr for Radarr
  # Disabled: needs API key configuration
  # systemd.services.exportarr-radarr = {
  #   description = "Exportarr Prometheus Exporter for Radarr";
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     DynamicUser = true;
  #     ExecStart = "${pkgs.exportarr}/bin/exportarr radarr --port ${toString ports.radarr} --url http://localhost:7878";
  #     Restart = "on-failure";
  #   };
  # };

  # Exportarr for Lidarr
  # Disabled: needs API key configuration
  # systemd.services.exportarr-lidarr = {
  #   description = "Exportarr Prometheus Exporter for Lidarr";
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     DynamicUser = true;
  #     ExecStart = "${pkgs.exportarr}/bin/exportarr lidarr --port ${toString ports.lidarr} --url http://localhost:8686";
  #     Restart = "on-failure";
  #   };
  # };

  # Exportarr for Bazarr
  # Disabled: needs API key configuration
  # systemd.services.exportarr-bazarr = {
  #   description = "Exportarr Prometheus Exporter for Bazarr";
  #   wantedBy = ["multi-user.target"];
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     DynamicUser = true;
  #     ExecStart = "${pkgs.exportarr}/bin/exportarr bazarr --port ${toString ports.bazarr} --url http://localhost:6767";
  #     Restart = "on-failure";
  #   };
  # };

  # Deluge exporter
  systemd.services.deluge-exporter = {
    description = "Deluge Prometheus Exporter";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      ExecStart = "${pkgs.prometheus-deluge-exporter}/bin/deluge-exporter localhost:58846 --addr :${toString ports.deluge}";
      Restart = "on-failure";
    };
  };

  # Samba exporter - using a simple script to expose smbstatus metrics
  # For now, we'll skip this and can add later if needed

  # Open firewall ports for Prometheus exporters
  networking.firewall = {
    # Allow from Tailscale network
    interfaces."tailscale0".allowedTCPPorts = [
      ports.node
      ports.systemd
      ports.process
      ports.cadvisor
      ports.caddy
      ports.jellyfin
      ports.pihole
      # ports.sonarr  # Disabled - needs API key
      # ports.radarr  # Disabled - needs API key
      # ports.lidarr  # Disabled - needs API key
      # ports.bazarr  # Disabled - needs API key
      ports.deluge
    ];
  };
}
