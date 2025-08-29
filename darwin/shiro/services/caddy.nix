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
      environmentFile = config.sops.templates."HETZNER_API_KEY.env".path;
      globalConfig = ''
        debug
      '';
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
    };
  };
}
