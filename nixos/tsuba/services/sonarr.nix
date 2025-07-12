{...}: {
  services = {
    sonarr.enable = true;
    caddy = {
      virtualHosts."sonarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:8989
      '';
    };
  };
}
