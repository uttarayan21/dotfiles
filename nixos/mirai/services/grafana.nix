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
        import auth
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
