{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.atuin or {};
in {
  config = mkIf (cfg.enable or false) {
    services.atuin = {
      enable = true;
      openRegistration = false;
    };
  };
}
