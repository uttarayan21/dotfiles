{
  pkgs,
  config,
  lib,
  ...
}: {
  sops = {
    secrets."paperless/adminpass".owner = config.users.users.paperless.name;
    secrets."paperless/secret_key".owner = config.users.users.paperless.name;
    secrets."authelia/oidc/paperless/client_id".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
    secrets."authelia/oidc/paperless/client_secret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
    templates = {
      "PAPERLESS.env" = {
        content = ''
          PAPERLESS_SOCIALACCOUNT_PROVIDERS='${config.sops.templates."PAPERLESS_SOCIALACCOUNT_PROVIDERS.json".content}'
        '';
        restartUnits = ["paperless-web.service" "authelia-darksailor.service"];
      };
      "PAPERLESS_SOCIALACCOUNT_PROVIDERS.json" = {
        content =
          /*
          json
          */
          builtins.toJSON
          {
            authelia = {
              OAUTH_PKCE_ENABLED = "True";
              APPS = [
                {
                  provider_id = "authelia";
                  name = "Authelia";
                  "client_id" = "${config.sops.placeholder."authelia/oidc/paperless/client_id"}";
                  "secret" = "${config.sops.placeholder."authelia/oidc/paperless/client_secret"}";
                  "settings" = {
                    "server_url" = "https://auth.darksailor.dev/.well-known/openid-configuration";
                  };
                }
              ];
            };
          };
        restartUnits = ["paperless-web.service" "authelia-darksailor.service"];
      };
    };
  };
  # systemd.services.paperless-web.script = lib.mkBefore ''
  #   oidcSecret=$(< ${config.sops.secrets."authelia/oidc/paperless/client_secret".path})
  #   export PAPERLESS_SOCIALACCOUNT_PROVIDERS=$(
  #     ${pkgs.jq}/bin/jq <<< "$PAPERLESS_SOCIALACCOUNT_PROVIDERS" \
  #       --compact-output \
  #       --arg oidcSecret "$oidcSecret" '.openid_connect.APPS.[0].secret = $oidcSecret'
  #   )
  # '';
  services = {
    paperless = {
      enable = true;
      passwordFile = config.sops.secrets."paperless/adminpass".path;
      settings = {
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
        PAPERLESS_SOCIAL_AUTO_SIGNUP = "True";
        PAPERLESS_DISABLE_REGULAR_LOGIN = "True";
        PAPERLESS_SOCIALACCOUNT_ALLOW_SIGNUPS = "True";
        PAPERLESS_URL = "https://paperless.darksailor.dev";
      };
      environmentFile = "${config.sops.templates."PAPERLESS.env".path}";
    };
    caddy = {
      virtualHosts."paperless.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:28981
      '';
    };

    authelia = {
      instances.darksailor = {
        settings = {
          identity_providers = {
            oidc = {
              clients = [
                {
                  client_name = "paperless";
                  client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/paperless/client_id".path}" }}'';
                  client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/paperless/client_secret".path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = false;
                  redirect_uris = [
                    "https://paperless.darksailor.dev/auth/login"
                  ];
                  scopes = ["openid" "profile" "email"];
                  response_types = ["code"];
                  grant_types = ["authorization_code"];
                  # access_token_signed_response_alg = "none";
                  userinfo_signed_response_alg = "none";
                  token_endpoint_auth_method = "client_secret_post";
                }
              ];
            };
          };
        };
      };
    };
  };
}
