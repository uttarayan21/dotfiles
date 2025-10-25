{
  config,
  pkgs,
  lib,
  # devices,
  ...
}: {
  sops.secrets = {
    "grafana/adminPassword" = {
      owner = "grafana";
      group = "grafana";
    };
    oauth-client-secret-grafana-authelia = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      key = "authelia/oidc/grafana/client_secret";
      restartUnits = [
        "authelia-darksailor.service"
      ];
    };
    oauth-client-secret-grafana = {
      owner = config.systemd.services.grafana.serviceConfig.User;
      key = "authelia/oidc/grafana/client_secret";
      restartUnits = [
        "grafana"
      ];
    };
  };
  services = {
    prometheus = {
      enable = true;
      port = 9090;
      listenAddress = "0.0.0.0";

      scrapeConfigs = [];
      # ++ (lib.mapAttrsToList (name: cfg: {
      #     job_name = "mirai-" + name;
      #     static_configs = [
      #       {
      #         targets = [("localhost:" + (builtins.toString cfg.port))];
      #       }
      #     ];
      #   })
      #   (config.services.prometheus.exporters));

      retentionTime = "30d";

      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };
    };

    prometheus.exporters = {
      ping = {
        enable = true;
        settings = {
          targets = [
            "1.1.1.1"
            "ryu"
            "tsuba"
            "shiro"
          ];
          ping = {
            interval = "5s";
            timeout = "5s";
          };
        };
        openFirewall = true;
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
        ];
        openFirewall = true;
      };
      process = {
        enable = true;
        settings.process_names = [
          {
            name = "{{.Comm}}";
            cmdline = [".*"];
          }
        ];
        openFirewall = true;
      };
      systemd = {
        enable = true;
        openFirewall = true;
      };
    };

    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3333;
          domain = "monitoring.darksailor.dev";
          root_url = "https://monitoring.darksailor.dev";
        };
        security = {
          admin_user = "admin";
          admin_password = "$__file{${config.sops.secrets."grafana/adminPassword".path}}";
        };
        auth = {
          disable_login_form = true;
        };
        "auth.basic" = {
          enabled = false;
        };
        "auth.generic_oauth" = {
          enabled = true;
          name = "Authelia";
          client_id = "grafana";
          client_secret = "$__file{${config.sops.secrets.oauth-client-secret-grafana.path}}";
          scopes = "openid profile email groups";
          empty_scopes = false;
          auth_url = "https://auth.darksailor.dev/api/oidc/authorization";
          token_url = "https://auth.darksailor.dev/api/oidc/token";
          api_url = "https://auth.darksailor.dev/api/oidc/userinfo";
          login_attribute_path = "email";
          groups_attribute_path = "groups";
          name_attribute_path = "name";
          email_attribute_path = "email";
          username_attribute_path = "preferred_username";
          use_pkce = true;
          auto_login = true;
          allow_sign_up = true;
          role_attribute_path = "contains(groups[*], 'sso_admin') && 'Admin' || Viewer";
          use_refresh_token = false;
          id_token_attribute_name = "";
          signout_redirect_url = "https://auth.darksailor.dev/logout";
        };
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:9090";
            isDefault = true;
            jsonData = {
              timeInterval = "15s";
            };
          }
        ];

        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "default";
              type = "file";
              options.path = "/var/lib/grafana/dashboards";
            }
          ];
        };
      };
    };

    caddy.virtualHosts."monitoring.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:${builtins.toString config.services.grafana.settings.server.http_port}
    '';

    authelia = {
      instances.darksailor = {
        settings = {
          identity_providers = {
            oidc = {
              claims_policies = {
                grafana = {
                  id_token = [
                    "email"
                    "name"
                    "groups"
                    "preferred_username"
                  ];
                };
              };
              clients = [
                {
                  client_name = "Grafana";
                  client_id = "grafana";
                  claims_policy = "grafana";
                  client_secret = ''{{ secret "${config.sops.secrets.oauth-client-secret-grafana-authelia.path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = true;
                  pkce_challenge_method = "S256";
                  redirect_uris = [
                    "https://monitoring.darksailor.dev/login/generic_oauth"
                  ];
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                    "groups"
                  ];
                  response_types = ["code"];
                  grant_types = ["authorization_code"];
                  userinfo_signed_response_alg = "none";
                  id_token_signed_response_alg = "RS256";
                  access_token_signed_response_alg = "RS256";
                  token_endpoint_auth_method = "client_secret_basic";
                }
              ];
            };
          };
        };
      };
    };
  };

  # SOPS secrets for Grafana

  # Create dashboard directory and copy dashboards
  systemd.tmpfiles.rules = [
    "d /var/lib/grafana/dashboards 0755 grafana grafana"
    "C /var/lib/grafana/dashboards/tsuba-monitoring.json 0644 grafana grafana - ${./dashboards/tsuba-monitoring.json}"
    "C /var/lib/grafana/dashboards/ryu-monitoring.json 0644 grafana grafana - ${./dashboards/ryu-monitoring.json}"
    "C /var/lib/grafana/dashboards/mirai-monitoring.json 0644 grafana grafana - ${./dashboards/mirai-monitoring.json}"
    "C /var/lib/grafana/dashboards/overview-monitoring.json 0644 grafana grafana - ${./dashboards/overview-monitoring.json}"
    "C /var/lib/grafana/dashboards/enhanced-overview.json 0644 grafana grafana - ${./dashboards/enhanced-overview.json}"
    "C /var/lib/grafana/dashboards/systemd-monitoring.json 0644 grafana grafana - ${./dashboards/systemd-monitoring.json}"
  ];

  # Open firewall ports
  networking.firewall = {
    # Allow Tailscale traffic for metrics scraping
    trustedInterfaces = ["tailscale0"];
  };

  # Ensure Grafana service starts after PostgreSQL
  # systemd.services.grafana.after = ["postgresql.service"];
  # systemd.services.grafana.requires = ["postgresql.service"];
}
