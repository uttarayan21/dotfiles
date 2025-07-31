{config, ...}: {
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
    };
    # prometheus = {
    #   enable = true;
    # };
    caddy = {
      virtualHosts."grafana.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:${builtins.toString config.services.grafana.settings.server.http_port}
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
            ];
          };
        };
      };
    };
  };
}
