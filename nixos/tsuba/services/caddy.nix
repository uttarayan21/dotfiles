{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."cloudflare/api_key".owner = config.services.caddy.user;
    templates = {
      "CLOUDFLARE_API_KEY.env".content = ''
        CLOUDFLARE_API_KEY=${config.sops.placeholder."cloudflare/api_key"}
      '';
    };
  };
  services = {
    caddy = {
      enable = true;
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
            forward_auth https://auth.darksailor.dev {
               # header_up X-Forwarded-Host {upstream_hostport}
               uri /api/authz/forward-auth
               copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
        }
      '';
      package = pkgs.caddyWithCloudflare;
    };
  };
  systemd.services.caddy = {
    after = ["sops-install-secrets.service"];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."CLOUDFLARE_API_KEY.env".path;
    };
  };
}
