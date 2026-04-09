{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.deluge or {};
in {
  config = mkIf (cfg.enable or false) {
    services.deluge = {
      enable = true;
      web.enable = true;
      group = "media";
    };
  };
}
