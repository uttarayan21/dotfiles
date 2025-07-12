{...}: {
  services = {
    deluge = {
      enable = true;
      web.enable = true;
    };
    caddy = {
      virtualHosts."deluge.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:8112
      '';
    };
  };
}
