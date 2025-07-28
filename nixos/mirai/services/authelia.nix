{config, ...}: {
  sops = {
    secrets = let
      user = config.systemd.services.authelia-darksailor.serviceConfig.User;
    in {
      "authelia/servers/darksailor/jwtSecret".owner = user;
      "authelia/servers/darksailor/storageEncryptionSecret".owner = user;
      "authelia/servers/darksailor/sessionSecret".owner = user;
      "authelia/users/servius".owner = user;
      "authelia/oidc/immich".owner = user;
      users.owner = user;
    };
  };
  services = {
    authelia = {
      instances.darksailor = {
        enable = true;
        settings = {
          authentication_backend = {
            password_reset.disable = false;
            file = {
              path = "/run/secrets/users";
            };
          };
          identity_providers = {
            odic = {
              clients = [
                {
                  client_id = "immich";
                  client_name = "immich";
                  client_secret = ''{{ fileContent "${config.sops.secrets."authelia/oidc/immich".path}" }}'';
                  public = false;
                  authorization_policy = "two_factor";
                  require_pkce = false;
                  pkce_challenge_method = "";
                  redirect_uris = [
                    "https://photos.darksailor.dev/auth/login"
                    "https://photos.darksailor.dev/user-settings"
                    "app.immich:///oauth-callback"
                  ];
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                  ];
                  response_types = [
                    "code"
                  ];
                  grant_types = [
                    "authorization_code"
                  ];
                  access_token_signed_response_alg = "none";
                  userinfo_signed_response_alg = "none";
                  token_endpoint_auth_method = "client_secret_post";
                }
              ];
            };
          };
          session = {
            cookies = [
              {
                domain = "darksailor.dev";
                authelia_url = "https://auth.darksailor.dev";
                name = "authelia_session";
              }
            ];
          };
          access_control = {
            default_policy = "one_factor";
            rules = [
              # {
              #   domain = "darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "cloud.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "code.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "media.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "music.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "music.darksailor.dev";
              #   policy = "bypass";
              #   resources = [
              #     "^/rest([/?].*)?$"
              #     "^/share([/?].*)?$"
              #   ];
              # }
            ];
          };
          storage = {
            local = {
              path = "/var/lib/authelia-darksailor/authelia.sqlite3";
            };
          };
          theme = "dark";
          notifier.filesystem.filename = "/var/lib/authelia-darksailor/authelia-notifier.log";
          server = {
            address = "127.0.0.1:5555";
            endpoints.authz = {
              forward-auth = {
                implementation = "ForwardAuth";
              };
              auth-request = {
                implementation = "AuthRequest";
              };
            };
          };
        };
        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/servers/darksailor/jwtSecret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/servers/darksailor/storageEncryptionSecret".path;
          sessionSecretFile = config.sops.secrets."authelia/servers/darksailor/sessionSecret".path;
        };
      };
    };
    caddy = {
      virtualHosts."auth.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:5555
      '';
    };
  };
}
