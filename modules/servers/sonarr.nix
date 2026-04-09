{
  config,
  lib,
  pkgs,
  masterPkgs,
  ...
}:
with lib; let
  cfg = config.servers.sonarr or {};
in {
  config = mkIf (cfg.enable or false) {
    services.sonarr = {
      enable = true;
      package = masterPkgs.sonarr;
      group = "media";
      settings = {
        server.port = cfg.port;
        auth = {
          authentication_enabled = true;
          authentication_method = "External";
        };
      };
    };

    systemd.services.sonarr.serviceConfig.path = [pkgs.ffmpeg];
  };
}
