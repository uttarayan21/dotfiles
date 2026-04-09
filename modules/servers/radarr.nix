{
  config,
  lib,
  masterPkgs,
  ...
}:
with lib; let
  cfg = config.servers.radarr or {};
in {
  config = mkIf (cfg.enable or false) {
    services.radarr = {
      enable = true;
      package = masterPkgs.radarr;
      group = "media";
      settings = {
        server.port = cfg.port;
        auth = {
          authentication_enabled = true;
          authentication_method = "External";
        };
      };
    };
  };
}
