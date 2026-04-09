{
  config,
  lib,
  masterPkgs,
  ...
}:
with lib; let
  cfg = config.servers.prowlarr or {};
in {
  config = mkIf (cfg.enable or false) {
    services.prowlarr = {
      enable = true;
      package = masterPkgs.prowlarr;
      settings = {
        auth = {
          authentication_enabled = true;
          authentication_method = "External";
        };
      };
    };
  };
}
