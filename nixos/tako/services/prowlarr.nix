{config, ...}: {
  services = {
    prowlarr = {
      enable = true;
      settings = {
        auth = {
          authentication_enabled = true;
          authentication_method = "External";
        };
        # server.port = 9696;
      };
    };
  };
  services.caddy.virtualHosts."prowlarr.darksailor.dev".extraConfig = ''
    import auth
    reverse_proxy localhost:${toString config.services.prowlarr.settings.server.port or "9696"}
  '';
}
