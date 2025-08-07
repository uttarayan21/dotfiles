{
  lib,
  config,
  ...
}: {
  virtualisation.docker.enable = true;
  sops = {
    # secrets."gitea/registration".owner = config.systemd.services.gitea-actions-mirai.serviceConfig.User;
    secrets."gitea/registration" = {};
    secrets."authelia/oidc/gitea/client_id" = {
      owner = config.services.gitea.user;
      group = config.services.gitea.group;
      mode = "0440";
      restartUnits = ["gitea.service" "authelia-darksailor.service"];
    };
    secrets."authelia/oidc/gitea/client_secret" = {
      owner = config.services.gitea.user;
      group = config.services.gitea.group;
      mode = "0440";
      restartUnits = ["gitea.service" "authelia-darksailor.service"];
    };
    templates = {
      "GITEA_REGISTRATION_TOKEN.env".content = ''
        TOKEN=${config.sops.placeholder."gitea/registration"}
      '';
    };
  };
  services = {
    gitea = {
      enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = true;
        };
        "auth/authelia" = {
          AUTO_DISCOVER_URL = "https://auth.darksailor.dev/.well-known/openid-configuration";
          CLIENT_ID = config.sops.placeholder."authelia/oidc/gitea/client_id";
          CLIENT_SECRET_FILE = config.sops.secrets."authelia/oidc/gitea/client_secret".path;
          ICON_URL = "https://www.authelia.com/images/branding/logo-light.png";
          NAME = "authelia";
          PROVIDER = "openidConnect";
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "sendmail";
        };
        server = {
          ROOT_URL = "https://git.darksailor.dev";
          DOMAIN = "git.darksailor.dev";
        };
      };
    };
    gitea-actions-runner = {
      instances = {
        mirai = {
          enable = true;
          name = "mirai";
          url = "https://git.darksailor.dev";
          labels = [
            "ubuntu-latest:docker://node:18-bullseye"
          ];
          tokenFile = "${config.sops.templates."GITEA_REGISTRATION_TOKEN.env".path}";
        };
      };
    };
    caddy = {
      virtualHosts."git.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          identity_providers = {
            oidc = {
              clients = [
                {
                  client_name = "gitea";
                  client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_id".path}" }}'';
                  client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_secret".path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = true;
                  redirect_uris = [
                    "https://git.darksailor.dev/user/oauth2/authelia/callback"
                  ];
                  scopes = ["openid" "profile" "email" "groups"];
                  response_types = ["code"];
                  grant_types = ["authorization_code"];
                  userinfo_signed_response_alg = "none";
                  token_endpoint_auth_method = "client_secret_post";
                }
              ];
            };
          };
          access_control = {
            rules = [
              {
                domain = "git.darksailor.dev";
                policy = "bypass";
              }
            ];
          };
        };
      };
    };
  };
}
