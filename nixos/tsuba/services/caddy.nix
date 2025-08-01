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
    tailscaleAuth = {
      enable = true;
      user = config.services.caddy.user;
      group = config.services.caddy.group;
    };
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
           forward_auth unix/${config.services.tailscaleAuth.socketPath} {
                uri /auth
                header_up Remote-Addr {remote_host}
                header_up Remote-Port {remote_port}
                header_up Original-URI {uri}
                copy_headers {
                    Tailscale-User>X-Webauth-User
                    Tailscale-Name>X-Webauth-Name
                    Tailscale-Login>X-Webauth-Login
                    Tailscale-Tailnet>X-Webauth-Tailnet
                    Tailscale-Profile-Picture>X-Webauth-Profile-Picture
                }
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
