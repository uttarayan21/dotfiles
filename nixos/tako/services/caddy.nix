{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hosts."127.0.0.1" = lib.unique (map
    (n: lib.removePrefix "https://" (lib.removePrefix "http://" n))
    (lib.attrNames config.services.caddy.virtualHosts));

  sops = {
    secrets."cloudflare/cf_api_key".owner = config.services.caddy.user;
    templates."CLOUDFLARE_API_KEY.env" = {
      content = ''
        CLOUDFLARE_API_KEY=${config.sops.placeholder."cloudflare/cf_api_key"}
      '';
      owner = config.services.caddy.user;
      restartUnits = ["caddy.service"];
    };
  };

  systemd.services.caddy = {
    after = ["sops-install-secrets.service"];
    serviceConfig.EnvironmentFile = config.sops.templates."CLOUDFLARE_API_KEY.env".path;
  };

  services = {
    caddy = {
      enable = true;
      package = pkgs.caddyWithCloudflare;
      globalConfig = ''
        servers {
          metrics
        }
        metrics {
          per_host
        }
      '';
      extraConfig = ''
        (cloudflare) {
            tls {
                propagation_timeout -1
                propagation_delay 120s
                dns cloudflare {env.CLOUDFLARE_API_KEY}
                resolvers 1.1.1.1
            }
        }
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
