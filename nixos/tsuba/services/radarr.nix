{...}: {
  services = {
    radarr.enable = true;
    caddy = {
      virtualHosts."radarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:7878
      '';
    };
  };
}
