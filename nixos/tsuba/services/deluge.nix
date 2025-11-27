{...}: {
  services = {
    deluge = {
      enable = true;
      web.enable = true;
      group = "media";
    };
    caddy = {
      virtualHosts."deluge.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:8112
      '';
    };
  };
}
