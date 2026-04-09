{
  config,
  lib,
  masterPkgs,
  ...
}:
with lib; let
  cfg = config.servers.bazarr or {};
in {
  config = mkIf (cfg.enable or false) {
    services.bazarr = {
      enable = true;
      package = masterPkgs.bazarr;
      group = "media";
    };
  };
}
