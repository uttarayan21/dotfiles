{
  config,
  pkgs,
  lib,
  ...
}: let
  # Port configurations
  ports = {
    grafana = 3001; # Changed from 3000 to avoid clash with Gitea
    prometheus = 9090;

    # System exporters
    node = 9100;
    systemd = 9558;
    process = 9256;

    # Infrastructure exporters
    postgres = 9187;
    redis = 9121;
    cadvisor = 8080;

    # Application exporters
    caddy = 2019;
  };
in {
  # Grafana configuration with Authelia integration
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = ports.grafana;
        domain = "grafana.darksailor.dev";
        root_url = "https://grafana.darksailor.dev";
      };

      # Disable Grafana's own auth since we use Authelia
      auth.disable_login_form = true;
      "auth.basic".enabled = false;
      "auth.anonymous".enabled = false;
      "auth.proxy" = {
        enabled = true;
        header_name = "REMOTE-USER";
        header_property = "username";
        auto_sign_up = true;
      };

      users = {
        allow_sign_up = false;
        auto_assign_org = true;
        auto_assign_org_role = "Admin";
      };

      security = {
        disable_gravatar = true;
        cookie_secure = true;
      };

      analytics = {
        reporting_enabled = false;
        check_for_updates = false;
      };
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://localhost:${toString ports.prometheus}";
          isDefault = true;
          jsonData = {
            timeInterval = "30s";
          };
        }
      ];

      # Provision popular community dashboards
      dashboards = {
        settings = {
          apiVersion = 1;
          providers = [
            {
              name = "default";
              orgId = 1;
              folder = "";
              type = "file";
              disableDeletion = false;
              updateIntervalSeconds = 10;
              allowUiUpdates = true;
              options.path = "/var/lib/grafana/dashboards";
            }
          ];
        };
      };
    };
  };

  # Caddy virtual host for Grafana with Authelia
  services.caddy.virtualHosts."grafana.darksailor.dev".extraConfig = ''
    import auth
    reverse_proxy localhost:${toString ports.grafana}
  '';

  # Central Prometheus server
  services.prometheus = {
    enable = true;
    port = ports.prometheus;

    # Retention settings (90 days)
    retentionTime = "90d";

    # Global scrape config
    globalConfig = {
      scrape_interval = "30s";
      evaluation_interval = "30s";
    };

    # System exporters for tako
    exporters = {
      node = {
        enable = true;
        port = ports.node;
        enabledCollectors = [
          "systemd"
          "textfile"
          "filesystem"
          "loadavg"
          "meminfo"
          "netdev"
          "netstat"
          "stat"
          "time"
          "uname"
          "vmstat"
          "diskstats"
          "cpu"
        ];
      };

      systemd = {
        enable = true;
        port = ports.systemd;
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

      postgres = {
        enable = true;
        port = ports.postgres;
        runAsLocalSuperUser = true;
      };

      redis = {
        enable = true;
        port = ports.redis;
      };
    };

    # Scrape configurations for all targets
    scrapeConfigs = [
      # System metrics - tako (local)
      {
        job_name = "tako-system";
        static_configs = [
          {
            targets = [
              "localhost:${toString ports.node}"
              "localhost:${toString ports.systemd}"
              "localhost:${toString ports.process}"
            ];
            labels = {
              instance = "tako";
              machine = "tako";
              role = "server";
            };
          }
        ];
      }

      # Infrastructure - tako
      {
        job_name = "tako-infrastructure";
        static_configs = [
          {
            targets = [
              "localhost:${toString ports.postgres}"
              "localhost:${toString ports.redis}"
              "localhost:${toString ports.cadvisor}"
            ];
            labels = {
              instance = "tako";
              machine = "tako";
            };
          }
        ];
      }

      # Caddy metrics - tako
      {
        job_name = "tako-caddy";
        static_configs = [
          {
            targets = ["localhost:${toString ports.caddy}"];
            labels = {
              instance = "tako";
              machine = "tako";
              service = "caddy";
            };
          }
        ];
      }

      # Application metrics - tako
      {
        job_name = "tako-applications";
        static_configs = [
          {
            targets = [
              "localhost:3000" # gitea
              "localhost:5555" # authelia (if metrics enabled)
            ];
            labels = {
              instance = "tako";
              machine = "tako";
            };
          }
        ];
      }

      # System metrics - tsuba (remote via Tailscale)
      {
        job_name = "tsuba-system";
        static_configs = [
          {
            targets = [
              "tsuba:9100" # node
              "tsuba:9558" # systemd
              "tsuba:9256" # process
            ];
            labels = {
              instance = "tsuba";
              machine = "tsuba";
              role = "server";
            };
          }
        ];
      }

      # Infrastructure - tsuba
      {
        job_name = "tsuba-infrastructure";
        static_configs = [
          {
            targets = [
              "tsuba:8080" # cadvisor
              "tsuba:2019" # caddy
            ];
            labels = {
              instance = "tsuba";
              machine = "tsuba";
            };
          }
        ];
      }

      # Media services - tsuba
      {
        job_name = "tsuba-media";
        static_configs = [
          {
            targets = [
              "tsuba:8096" # jellyfin (built-in /metrics endpoint)
              "tsuba:8123" # homeassistant (configure prometheus integration)
              "tsuba:9617" # pihole-exporter
            ];
            labels = {
              instance = "tsuba";
              machine = "tsuba";
            };
          }
        ];
        metrics_path = "/metrics";
        relabel_configs = [
          {
            source_labels = ["__address__"];
            regex = "tsuba:8096";
            target_label = "__metrics_path__";
            replacement = "/metrics";
          }
          {
            source_labels = ["__address__"];
            regex = "tsuba:8123";
            target_label = "__metrics_path__";
            replacement = "/api/prometheus";
          }
        ];
      }

      # Servarr stack - tsuba (exportarr)
      {
        job_name = "tsuba-servarr";
        static_configs = [
          {
            targets = [
              "tsuba:9707" # sonarr
              "tsuba:9708" # radarr
              "tsuba:9709" # lidarr
              "tsuba:9710" # bazarr
            ];
            labels = {
              instance = "tsuba";
              machine = "tsuba";
              stack = "servarr";
            };
          }
        ];
      }

      # Deluge - tsuba
      {
        job_name = "tsuba-deluge";
        static_configs = [
          {
            targets = ["tsuba:9354"];
            labels = {
              instance = "tsuba";
              machine = "tsuba";
              service = "deluge";
            };
          }
        ];
      }

      # System metrics - ryu (remote via Tailscale)
      {
        job_name = "ryu-system";
        static_configs = [
          {
            targets = [
              "ryu:9100"
              "ryu:9558"
              "ryu:9256"
              "ryu:9835" # nvidia-gpu
            ];
            labels = {
              instance = "ryu";
              machine = "ryu";
              role = "desktop";
            };
          }
        ];
      }

      # Infrastructure - ryu
      {
        job_name = "ryu-infrastructure";
        static_configs = [
          {
            targets = [
              "ryu:8080" # cadvisor
              "ryu:2019" # caddy
            ];
            labels = {
              instance = "ryu";
              machine = "ryu";
            };
          }
        ];
      }
    ];
  };

  # Docker cAdvisor for container metrics
  virtualisation.oci-containers.containers.cadvisor = {
    image = "gcr.io/cadvisor/cadvisor:v0.49.1";
    ports = ["127.0.0.1:${toString ports.cadvisor}:8080"];
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

  # Link dashboard files from Nix store to Grafana's expected location
  systemd.tmpfiles.rules = let
    # Define dashboard files with proper hashes
    nodeExporterFull = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
      sha256 = "0qza4j8lywrj08bqbww52dgh2p2b9rkhq5p313g72i57lrlkacfl";
    };
    nvidiaDashboardRaw = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/14574/revisions/9/download";
      sha256 = "170ijap5i99sapkxlf3k0lnvwmb6g9jkk7q66nwjwswkj2a7rqbr";
    };
    # Fix NVIDIA dashboard to use our Prometheus datasource
    nvidiaDashboard = pkgs.runCommand "nvidia-gpu-fixed.json" {} ''
      ${pkgs.gnused}/bin/sed 's/\''${DS_PROMETHEUS}/Prometheus/g' ${nvidiaDashboardRaw} > $out
    '';
    postgresqlDashboardRaw = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/9628/revisions/7/download";
      sha256 = "0xmk68kqb9b8aspjj2f8wxv2mxiqk9k3xs0yal4szmzbv65c6k66";
    };
    # Fix PostgreSQL dashboard to use our Prometheus datasource
    postgresqlDashboard = pkgs.runCommand "postgresql-fixed.json" {} ''
      ${pkgs.gnused}/bin/sed 's/\''${DS_PROMETHEUS}/Prometheus/g' ${postgresqlDashboardRaw} > $out
    '';
    redisDashboard = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/11835/revisions/1/download";
      sha256 = "15lbn4i8j5hiypl4dsg0d72jgrgjwpagkf5kcwx66gyps17jcrxx";
    };
    dockerDashboardRaw = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/193/revisions/1/download";
      sha256 = "1lxbbl91fh0yfh8x53205b7nw5ivghlpfb0m308z2p6fzvz2iq2m";
    };
    # Fix Docker dashboard to use our Prometheus datasource
    dockerDashboard = pkgs.runCommand "docker-cadvisor-fixed.json" {} ''
      ${pkgs.gnused}/bin/sed 's/\''${DS_PROMETHEUS}/Prometheus/g' ${dockerDashboardRaw} > $out
    '';
    caddyDashboardRaw = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/14280/revisions/1/download";
      sha256 = "0j3q68cq1nj8gcxkqz5h1kn1ds5kgq4jlkw73xp6yc88mbm5nyh4";
    };
    # Fix Caddy dashboard to use our Prometheus datasource
    caddyDashboard = pkgs.runCommand "caddy-fixed.json" {} ''
      ${pkgs.gnused}/bin/sed 's/\''${DS_PROMETHEUS}/Prometheus/g' ${caddyDashboardRaw} > $out
    '';
    piholeDashboardRaw = pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/10176/revisions/3/download";
      sha256 = "18f8w3l5k178agipfbimg29lkf2i32xynin1g1v5abiac3ahj7ih";
    };
    # Fix Pi-hole dashboard to use our Prometheus datasource
    piholeDashboard = pkgs.runCommand "pihole-fixed.json" {} ''
      ${pkgs.gnused}/bin/sed 's/\''${DS_PROMETHEUS}/Prometheus/g' ${piholeDashboardRaw} > $out
    '';
  in [
    "d /var/lib/grafana/dashboards 0755 grafana grafana -"
    "L+ /var/lib/grafana/dashboards/node-exporter-full.json - - - - ${nodeExporterFull}"
    "L+ /var/lib/grafana/dashboards/nvidia-gpu.json - - - - ${nvidiaDashboard}"
    "L+ /var/lib/grafana/dashboards/postgresql.json - - - - ${postgresqlDashboard}"
    "L+ /var/lib/grafana/dashboards/redis.json - - - - ${redisDashboard}"
    "L+ /var/lib/grafana/dashboards/docker-cadvisor.json - - - - ${dockerDashboard}"
    "L+ /var/lib/grafana/dashboards/caddy.json - - - - ${caddyDashboard}"
    "L+ /var/lib/grafana/dashboards/pihole.json - - - - ${piholeDashboard}"
  ];

  # Open firewall ports for Prometheus to scrape exporters
  networking.firewall = {
    # allowedTCPPorts = [
    #   ports.node
    #   ports.systemd
    #   ports.process
    # ];

    # Allow Prometheus and Grafana access from Tailscale network
    interfaces."tailscale0".allowedTCPPorts = [
      ports.prometheus
      ports.grafana
      ports.node
      ports.systemd
      ports.process
      ports.postgres
      ports.redis
      ports.cadvisor
    ];
  };
}
