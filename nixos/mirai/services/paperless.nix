{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets."paperless/adminpass".owner = config.users.users.paperless.name;
    secrets."paperless/secret_key".owner = config.users.users.paperless.name;
    templates = {
      "PAPERLESS.env".content = ''
        PAPERLESS_APPS="allauth.socialaccount.providers.github"
        PAPERLESS_SOCIALACCOUNT_PROVIDERS='{"authelia": {"APPS": [{"provider_id": "authelia","name": "Authelia","client_id": "${config.sops.placeholder."authelia/oidc/paperless/client_id"}","secret": "${config.sops.placeholder."authelia/oidc/paperless/client_secret"}"}]}}'
        # PAPERLESS_ENABLE_HTTP_REMOTE_USER=true
        PAPERLESS_URL=https://paperless.darksailor.dev
        PAPERLESS_SECRET_KEY=${config.sops.placeholder."paperless/secret_key"}
      '';
    };
  };
  services = {
    paperless = {
      enable = true;
      passwordFile = config.sops.secrets."paperless/adminpass".path;
      environmentFile = "${config.sops.templates."PAPERLESS.env".path}";
    };
    caddy = {
      virtualHosts."paperless.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:28981
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "paperless.darksailor.dev";
                policy = "bypass";
                resources = [
                  "^/api([/?].*)?$"
                ];
              }
              {
                domain = "paperless.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
}
