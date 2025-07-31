{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets."authelia/oidc/immich/client_id" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
      restartUnits = ["immich-server.service" "authelia-darksailor.service"];
    };
    secrets."authelia/oidc/immich/client_secret" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
      restartUnits = ["immich-server.service" "authelia-darksailor.service"];
    };
    templates = {
      "immich-config.json" = {
        content =
          /*
          json
          */
          ''
            {
              "oauth": {
                "clientId": "${config.sops.placeholder."authelia/oidc/immich/client_id"}",
                "clientSecret": "${config.sops.placeholder."authelia/oidc/immich/client_secret"}",
                "enabled": true,
                "autoLaunch": true,
                "autoRegister": true,
                "buttonText": "Login with Authelia",
                "scope": "openid email profile",
                "issuerUrl": "https://auth.darksailor.dev"
              },
              "passwordLogin" : {
                "enabled": false
              },
              "server": {
                "externalDomain": "https://photos.darksailor.dev"
              },
              {
                "machineLearning": {
                    "enabled": true,
                    "urls": [
                        "http://ryu:3003",
                        "http://localhost:3003"
                    ],
                }
              }
            }
          '';
        mode = "0400";
        owner = "immich";
        restartUnits = ["immich-server.service" "authelia-darksailor.service"];
      };
    };
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      immich-machine-learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:v${pkgs.immich.version}";
        ports = [
          "127.0.0.1:3003:3003"
        ];
        volumes = [
          "model-cache:/cache"
        ];
      };
    };
  };
  services.immich = {
    enable = true;
    mediaLocation = "/media/photos/immich";
    accelerationDevices = null;
    environment = {
      IMMICH_CONFIG_FILE = config.sops.templates."immich-config.json".path;
    };
    package = pkgs.immich;
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
                client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/immich/client_id".path}" }}'';
                client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/immich/client_secret".path}" }}'';
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
}
