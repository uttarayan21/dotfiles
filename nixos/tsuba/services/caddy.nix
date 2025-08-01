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
           forward_auth auth.darksailor.dev {
               uri /api/authz/forward_auth?rd=https://auth.darksailor.dev
               copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
           }
        }
      '';
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/hetzner@v1.0.0"];
        hash = "sha256-9ea0CfOHG7JhejB73HjfXQpnonn+ZRBqLNz1fFRkcDQ=";
      };
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."HETZNER_API_KEY.env".path;
    };
  };
}
