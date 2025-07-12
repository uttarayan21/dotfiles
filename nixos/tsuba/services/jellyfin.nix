{...}: {
  services = {
    # jellyfin.enable = true;
    jellyseerr.enable = true;
    caddy = {
      virtualHosts."jellyfin.tsuba.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };
}
