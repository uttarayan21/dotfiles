{
  config,
  pkgs,
  lib,
  device,
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
  networking.domains.subDomains = {
    "monitoring.darksailor.dev" = {};
    "grafana.darksailor.dev".a.data = device.tailscaleIp;
  };

  sops.secrets = let
    autheliaUser = config.systemd.services.authelia-darksailor.serviceConfig.User;
  in {
    "grafana/secret_key".owner = "grafana";
    "authelia/oidc/grafana/client_id".owner = autheliaUser;
    "authelia/oidc/grafana/client_secret_digest".owner = autheliaUser;
    "grafana/oidc/client_id" = {
      key = "authelia/oidc/grafana/client_id";
      owner = "grafana";
    };
    "grafana/oidc/client_secret" = {
      key = "authelia/oidc/grafana/client_secret_plain";
      owner = "grafana";
    };
  };

  # Grafana configuration with Authelia OIDC
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = ports.grafana;
        domain = "grafana.darksailor.dev";
        root_url = "https://grafana.darksailor.dev";
      };

      auth = {
        disable_login_form = true;
        oauth_auto_login = true;
      };
      "auth.basic".enabled = false;
      "auth.anonymous".enabled = false;
      "auth.generic_oauth" = {
        enabled = true;
        name = "Authelia";
        icon = "signin";
        client_id = "$__file{${config.sops.secrets."grafana/oidc/client_id".path}}";
        client_secret = "$__file{${config.sops.secrets."grafana/oidc/client_secret".path}}";
        scopes = "openid profile email groups";
        empty_scopes = false;
        auth_url = "https://auth.darksailor.dev/api/oidc/authorization";
        token_url = "https://auth.darksailor.dev/api/oidc/token";
        api_url = "https://auth.darksailor.dev/api/oidc/userinfo";
        login_attribute_path = "preferred_username";
        groups_attribute_path = "groups";
        name_attribute_path = "name";
        use_pkce = true;
        allow_sign_up = true;
        auth_style = "InHeader";
        role_attribute_path = "contains(groups[*], 'admins') && 'Admin' || contains(groups[*], 'editors') && 'Editor' || 'Viewer'";
        role_attribute_strict = false;
      };

      users = {
        allow_sign_up = false;
        auto_assign_org = true;
        auto_assign_org_role = "Admin";
      };

      security = {
        disable_gravatar = true;
        cookie_secure = true;
        secret_key = ''$__file{${config.sops.secrets."grafana/secret_key".path}}'';
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
          uid = "prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://localhost:${toString ports.prometheus}";
          isDefault = true;
          jsonData = {
            timeInterval = "30s";
          };
        }
      ];

      alerting = {
        rules.settings = {
          apiVersion = 1;
          groups = [
            {
              orgId = 1;
              name = "gitea";
              folder = "Alerts";
              interval = "1m";
              rules = [
                {
                  uid = "gitea_slow_scrape";
                  title = "Gitea slow / stalled";
                  condition = "C";
                  for = "5m";
                  noDataState = "NoData";
                  execErrState = "Error";
                  annotations = {
                    summary = "Gitea /metrics scrape > 2s for 5m";
                    description = "scrape_duration_seconds for tako gitea (localhost:3000) > 2s — web handler likely stalled (see common/maintenancemode.go). Restart: systemctl restart gitea.";
                  };
                  labels = {
                    severity = "warning";
                    service = "gitea";
                  };
                  data = [
                    {
                      refId = "A";
                      relativeTimeRange = {
                        from = 600;
                        to = 0;
                      };
                      datasourceUid = "prometheus";
                      model = {
                        refId = "A";
                        expr = ''scrape_duration_seconds{job="tako-applications",instance="localhost:3000"}'';
                        instant = true;
                        intervalMs = 60000;
                        maxDataPoints = 43200;
                      };
                    }
                    {
                      refId = "C";
                      relativeTimeRange = {
                        from = 0;
                        to = 0;
                      };
                      datasourceUid = "__expr__";
                      model = {
                        refId = "C";
                        type = "threshold";
                        expression = "A";
                        conditions = [
                          {
                            type = "query";
                            evaluator = {
                              type = "gt";
                              params = [2];
                            };
                            operator.type = "and";
                            query.params = ["C"];
                            reducer.type = "last";
                          }
                        ];
                      };
                    }
                  ];
                }
                {
                  uid = "gitea_down";
                  title = "Gitea down";
                  condition = "C";
                  for = "2m";
                  noDataState = "Alerting";
                  execErrState = "Error";
                  annotations = {
                    summary = "Gitea scrape failing for 2m";
                    description = "up{job=tako-applications,instance=localhost:3000} == 0 — gitea web port not responding to Prometheus.";
                  };
                  labels = {
                    severity = "critical";
                    service = "gitea";
                  };
                  data = [
                    {
                      refId = "A";
                      relativeTimeRange = {
                        from = 600;
                        to = 0;
                      };
                      datasourceUid = "prometheus";
                      model = {
                        refId = "A";
                        expr = ''up{job="tako-applications",instance="localhost:3000"}'';
                        instant = true;
                        intervalMs = 60000;
                        maxDataPoints = 43200;
                      };
                    }
                    {
                      refId = "C";
                      relativeTimeRange = {
                        from = 0;
                        to = 0;
                      };
                      datasourceUid = "__expr__";
                      model = {
                        refId = "C";
                        type = "threshold";
                        expression = "A";
                        conditions = [
                          {
                            type = "query";
                            evaluator = {
                              type = "lt";
                              params = [1];
                            };
                            operator.type = "and";
                            query.params = ["C"];
                            reducer.type = "last";
                          }
                        ];
                      };
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

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

  # Caddy virtual host for Grafana — auth handled by Grafana via OIDC.
  # DNS-01 challenge needed because grafana.darksailor.dev resolves to a
  # tailscale CGNAT IP, unreachable from Let's Encrypt validators.
  services.caddy.virtualHosts."grafana.darksailor.dev".extraConfig = ''
    import cloudflare
    @internal remote_ip 100.64.0.0/10 127.0.0.1/32 ::1/128
    handle @internal {
      reverse_proxy localhost:${toString ports.grafana}
    }
    respond "Access denied" 403
  '';

  # Register Grafana as an OIDC client in Authelia
  services.authelia.instances.darksailor.settings.identity_providers.oidc.clients = [
    {
      client_name = "Grafana";
      client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/grafana/client_id".path}" }}'';
      client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/grafana/client_secret_digest".path}" }}'';
      public = false;
      authorization_policy = "one_factor";
      require_pkce = true;
      pkce_challenge_method = "S256";
      redirect_uris = [
        "https://grafana.darksailor.dev/login/generic_oauth"
      ];
      scopes = [
        "openid"
        "profile"
        "email"
        "groups"
      ];
      response_types = ["code"];
      grant_types = ["authorization_code"];
      access_token_signed_response_alg = "none";
      userinfo_signed_response_alg = "none";
      token_endpoint_auth_method = "client_secret_basic";
    }
  ];

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
        listenAddress = "0.0.0.0";
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
              # "tsuba:8123" # homeassistant (configure prometheus integration)
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
          # {
          #   source_labels = ["__address__"];
          #   regex = "tsuba:8123";
          #   target_label = "__metrics_path__";
          #   replacement = "/api/prometheus";
          # }
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
  # virtualisation.oci-containers.containers.cadvisor = {
  #   image = "gcr.io/cadvisor/cadvisor:v0.49.1";
  #   ports = ["127.0.0.1:${toString ports.cadvisor}:8080"];
  #   volumes = [
  #     "/:/rootfs:ro"
  #     "/var/run:/var/run:ro"
  #     "/sys:/sys:ro"
  #     "/var/lib/docker/:/var/lib/docker:ro"
  #     "/dev/disk/:/dev/disk:ro"
  #   ];
  #   extraOptions = [
  #     "--privileged"
  #     "--device=/dev/kmsg"
  #   ];
  # };

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
