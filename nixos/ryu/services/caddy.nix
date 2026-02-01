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
      globalConfig = ''
        servers {
          metrics
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
