{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."hetzner/api_key".owner = config.services.caddy.user;
    templates = {
      "HETZNER_API_KEY.env".content = ''
        HETZNER_API_KEY=${config.sops.placeholder."hetzner/api_key"}
      '';
    };
  };
  services = {
    caddy = {
      enable = true;
      extraConfig = ''
        (hetzner) {
            tls {
                propagation_timeout -1
                propagation_delay 120s
                dns hetzner {env.HETZNER_API_KEY}
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
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/hetzner@v1.0.0"];
        hash = "sha256-Iwsu3s1qOwavcmmnd1w4GVeCkU1HhlWAJXMuc5NOc24=";
      };
      # package = pkgs.caddyWithHetzner;
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      After = ["sops-install-secrets.service"];
      EnvironmentFile = config.sops.templates."HETZNER_API_KEY.env".path;
    };
  };
}
