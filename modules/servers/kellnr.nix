{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.kellnr or {};
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."kellnr/password" = {};
      secrets."kellnr/token" = {};
      templates."kellnr.env".content = ''
        KELLNR_SETUP__ADMIN_PWD=${config.sops.placeholder."kellnr/password"}
        KELLNR_SETUP__ADMIN_TOKEN=${config.sops.placeholder."kellnr/token"}
      '';
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.kellnr = {
        image = "ghcr.io/kellnr/kellnr:5";
        ports = ["127.0.0.1:${toString cfg.port}:8000"];
        volumes = ["/var/lib/kellnr:/opt/kdata"];
        environment = {
          KELLNR_ORIGIN__HOSTNAME = cfg.domain;
          KELLNR_DOCS__ENABLED = "true";
          KELLNR_ORIGIN__PROTOCOL = "https";
          KELLNR_ORIGIN__PORT = "443";
        };
        environmentFiles = [config.sops.templates."kellnr.env".path];
      };
    };
  };
}
