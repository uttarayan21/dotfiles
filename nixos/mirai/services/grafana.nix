{ config, ... }:
{
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3011;
        };
        "auth.proxy" = {
          enabled = true;
          header_name = "Remote-User";
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
            name = "system";
            orgId = 1;
            folder = "System";
            type = "file";
            disableDeletion = false;
            updateIntervalSeconds = 10;
            allowUiUpdates = true;
            options.path = "/etc/grafana/dashboards";
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
              cmdline = [ ".*" ];
            }
          ];
        };
      };
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "127.0.0.1:9100" ];
              labels = {
                device = "mirai";
                type = "server";
              };
            }
            {
              targets = [ "tsuba:9100" ];
              labels = {
                device = "tsuba";
                type = "server";
                arch = "aarch64";
              };
            }
            {
              targets = [ "ryu:9100" ];
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
              targets = [ "127.0.0.1:9256" ];
              labels = {
                device = "mirai";
                type = "server";
              };
            }
            {
              targets = [ "tsuba:9256" ];
              labels = {
                device = "tsuba";
                type = "server";
                arch = "aarch64";
              };
            }
            {
              targets = [ "ryu:9256" ];
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
              targets = [ "127.0.0.1:9090" ];
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
                policy = "bypass";
                resources = [
                  "^/api([/?].*)?$"
                ];
              }
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

  # Provision dashboards directly
  environment.etc = {
    "grafana/dashboards/system-dashboard.json".source = ./grafana/system-dashboard.json;
    "grafana/dashboards/processes-dashboard.json".source = ./grafana/processes-dashboard.json;
  };
}
