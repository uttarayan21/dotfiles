{config, ...}: {
  sops = {
    secrets."authelia/oidc/immich/client_id" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
    };
    secrets."authelia/oidc/immich/client_secret" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
    };
    templates = {
      "OAUTH_CLIENT.env" = {
        content = ''
          OAUTH_CLIENT_ID=${config.sops.placeholder."authelia/oidc/immich/client_id"}
          OAUTH_CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/immich/client_secret"}
        '';
        mode = "0400";
        owner = config.services.immich.user;
      };
    };
  };
  users.users.immich.extraGroups = [config.systemd.services.authelia-darksailor.serviceConfig.Group];
  services.immich = {
    enable = true;
    mediaLocation = "/media/photos/immich";
    settings = {
      oauth = {
        enabled = true;
        autoLaunch = true;
        autoRegister = true;
        buttonText = "Login with Authelia";
        clientId = "immich";
        scope = "openid email profile";
        issuerUrl = "https://auth.darksailor.dev/.well-known/openid-configuration";
      };
      passwordLogin = {
        enabled = false;
      };
    };
    secretsFile = config.sops.templates."OAUTH_CLIENT.env".path;
  };
  services.caddy = {
    virtualHosts."photos.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:${builtins.toString config.services.immich.port}
    '';
  };
  services.authelia = {
    instances.darksailor = {
      settings = {
        identity_providers = {
          oidc = {
            clients = [
              {
                client_name = "immich";
                client_id = ''{{- fileContent "${config.sops.secrets."authelia/oidc/immich/client_id".path}" }}'';
                client_secret = ''{{- fileContent "${config.sops.secrets."authelia/oidc/immich/client_secret".path}" }}'';
                public = false;
                authorization_policy = "one_factor";
                require_pkce = false;
                redirect_uris = [
                  "https://photos.darksailor.dev/auth/login"
                  "https://photos.darksailor.dev/user-settings"
                  "app.immich:///oauth-callback"
                ];
                scopes = ["openid" "profile" "email"];
                response_types = ["code"];
                grant_types = ["authorization_code"];
                access_token_signed_response_alg = "none";
                userinfo_signed_response_alg = "none";
                token_endpoint_auth_method = "client_secret_post";
              }
            ];
          };
        };
      };
    };
  };
}
