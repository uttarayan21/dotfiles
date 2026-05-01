{
  config,
  lib,
  ...
}: {
  networking.hosts."127.0.0.1" = lib.unique (map
    (n: lib.removePrefix "https://" (lib.removePrefix "http://" n))
    (lib.attrNames config.services.caddy.virtualHosts));

  services = {
    caddy = {
      enable = true;
      globalConfig = ''
        servers {
          metrics
        }
      '';
      extraConfig = ''
        (auth) {
           forward_auth localhost:5555 {
               uri /api/authz/forward-auth?authelia_url=https://auth.darksailor.dev
               copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
           }
        }
      '';
    };
  };
}
