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
      '';
      package = pkgs.caddyWithHetzner;
      # package = pkgs.caddy.withPlugins {
      #   plugins = ["github.com/caddy-dns/hetzner@v1.0.0"];
      #   # hash = "sha256-9ea0CfOHG7JhejB73HjfXQpnonn+ZRBqLNz1fFRkcDQ=";
      #   # hash = "sha256-9ea0CfOHG7JhejB73HjfXQpnonn+ZRBqLNz1fFRkcDQ="
      #   hash = "sha256-YUrprDZQL+cX3P8fVLKHouXTMG4rw3sCaQdGqiq37uA=";
      # };
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."HETZNER_API_KEY.env".path;
      Requires = ["sops.service"];
      After = ["sops.service"];
    };
  };
}
