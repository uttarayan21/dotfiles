{config, ...}: {
  services = {
    grafana = {
      enable = true;
    };
    prometheus = {
      enable = true;
    };
    caddy = {
      virtualHosts."grafana.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.grafana.port}
      '';
    };
  };
}
