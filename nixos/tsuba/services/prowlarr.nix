{...}: {
  services = {
    prowlarr.enable = true;
    caddy = {
      virtualHosts."prowlarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:9696
      '';
    };
  };
}
