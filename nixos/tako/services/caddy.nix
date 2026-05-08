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
    templates."caddy.env" = {
      content = ''
        CF_API_TOKEN=${config.sops.secrets."cloudflare/cf_api_key"}
      '';
      owner = config.services.caddy.user;
      restartUnits = ["caddy.service"];
    };
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."caddy.env".path;

  services = {
    caddy = {
      enable = true;
      package = pkgs.caddyWithCloudflare;
      globalConfig = ''
        servers {
          metrics
        }
        # DNS-01 via Cloudflare — required for vhosts whose A record is
        # a tailscale CGNAT IP (LE rejects 100.64.0.0/10 for HTTP-01/TLS-ALPN-01)
        acme_dns cloudflare {env.CF_API_TOKEN}
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
