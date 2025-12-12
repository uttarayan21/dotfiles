{
  config,
  masterPkgs,
  ...
}: {
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
      package = masterPkgs.prowlarr;
    };
  };
  services.caddy.virtualHosts."prowlarr.darksailor.dev".extraConfig = ''
    import auth
    reverse_proxy localhost:${toString config.services.prowlarr.settings.server.port or "9696"}
  '';
}
