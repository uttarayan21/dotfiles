{config, ...}: {
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3011;
        };
        "auth.proxy" = {
          enabled = false;
          header_name = "Remote-User";
          header_property = "username";
          auto_sign_up = true;
          sync_ttl = 60;
          whitelist = "127.0.0.1";
          headers = "Name:Remote-Name Email:Remote-Email";
          enable_login_token = false;
        };
        users = {
          default_theme = "dark";
          home_page = "d/monitoring-homepage";
          auto_assign_org = true;
          auto_assign_org_id = 1;
          auto_assign_org_role = "Admin";
        };
        security = {
          allow_embedding = true;
          cookie_secure = false;
          disable_gravatar = true;
        };
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:9090";
            uid = "prometheus";
            isDefault = true;
          }
        ];
        dashboards.settings.providers = [
          {
            name = "homepage";
            orgId = 1;
            folder = "";
            type = "file";
            disableDeletion = false;
            updateIntervalSeconds = 10;
            allowUiUpdates = true;
            options.path = "/etc/grafana/dashboards/homepage";
          }
          {
            name = "multi-device";
            orgId = 1;
            folder = "Multi-Device Monitoring";
            type = "file";
            disableDeletion = false;
            updateIntervalSeconds = 10;
            allowUiUpdates = true;
            options.path = "/etc/grafana/dashboards/multi-device";
          }
          {
            name = "device-specific";
            orgId = 1;
            folder = "Device-Specific";
            type = "file";
            disableDeletion = false;
            updateIntervalSeconds = 10;
            allowUiUpdates = true;
            options.path = "/etc/grafana/dashboards/device-specific";
          }
          {
            name = "legacy";
            orgId = 1;
            folder = "Legacy Dashboards";
            type = "file";
            disableDeletion = false;
            updateIntervalSeconds = 10;
            allowUiUpdates = true;
            options.path = "/etc/grafana/dashboards/legacy";
          }
        ];
      };
    };

    prometheus = {
      enable = true;
      port = 9090;
      exporters = {
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
          ];
          port = 9100;
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
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = ["127.0.0.1:9100"];
              labels = {
                device = "mirai";
                type = "server";
              };
            }
            {
              targets = ["tsuba:9100"];
              labels = {
                device = "tsuba";
                type = "server";
                arch = "aarch64";
              };
            }
            {
              targets = ["ryu:9100"];
              labels = {
                device = "ryu";
                type = "desktop";
                arch = "x86_64";
              };
            }
          ];
        }
        {
          job_name = "process";
          static_configs = [
            {
              targets = ["127.0.0.1:9256"];
              labels = {
                device = "mirai";
                type = "server";
              };
            }
            {
              targets = ["tsuba:9256"];
              labels = {
                device = "tsuba";
                type = "server";
                arch = "aarch64";
              };
            }
            {
              targets = ["ryu:9256"];
              labels = {
                device = "ryu";
                type = "desktop";
                arch = "x86_64";
              };
            }
          ];
        }
        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = ["127.0.0.1:9090"];
              labels = {
                device = "mirai";
              };
            }
          ];
        }
      ];
    };

    caddy = {
      virtualHosts."grafana.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:${builtins.toString config.services.grafana.settings.server.http_port}
      '';
      virtualHosts."prometheus.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:${builtins.toString config.services.prometheus.port}
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "grafana.darksailor.dev";
                policy = "one_factor";
              }
              # {
              #   domain = "prometheus.darksailor.dev";
              #   policy = "bypass";
              #   resources = [
              #     "^/api([/?].*)?$"
              #   ];
              # }
              {
                domain = "prometheus.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };

  # Provision dashboards in organized folders
  environment.etc = {
    # Homepage dashboard (root level)
    "grafana/dashboards/homepage/homepage-dashboard.json".source =
      ./grafana/homepage/homepage-dashboard.json;

    # Multi-device dashboards
    "grafana/dashboards/multi-device/multi-device-system-dashboard.json".source =
      ./grafana/multi-device/multi-device-system-dashboard.json;
    "grafana/dashboards/multi-device/multi-device-processes-dashboard.json".source =
      ./grafana/multi-device/multi-device-processes-dashboard.json;

    # Device-specific dashboards
    "grafana/dashboards/device-specific/device-specific-system-dashboard.json".source =
      ./grafana/device-specific/device-specific-system-dashboard.json;

    # Legacy dashboards
    "grafana/dashboards/legacy/system-dashboard.json".source = ./grafana/legacy/system-dashboard.json;
    "grafana/dashboards/legacy/processes-dashboard.json".source =
      ./grafana/legacy/processes-dashboard.json;
  };
}
