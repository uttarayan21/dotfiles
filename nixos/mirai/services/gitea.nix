{
  lib,
  config,
  ...
}:
{
  virtualisation.docker.enable = true;
  sops = {
    # secrets."gitea/registration".owner = config.systemd.services.gitea-actions-mirai.serviceConfig.User;
    secrets."gitea/registration" = { };
    secrets."authelia/oidc/gitea/client_secret" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
      restartUnits = [
        "gitea.service"
        "authelia-darksailor.service"
      ];
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
      lfs.enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          SHOW_REGISTRATION_BUTTON = false;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = true;
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "sendmail";
        };
        security = {
          REVERSE_PROXY_AUTHENTICATION_USER = "REMOTE-USER";
        };
        server = {
          ROOT_URL = "https://git.darksailor.dev";
          DOMAIN = "git.darksailor.dev";
          # LFS_START_SERVER = true;
          LFS_ALLOW_PURE_SSH = true;
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "auto";
          OPENID_CONNECT_SCOPES = "openid profile email";
        };
      };
    };
    gitea-actions-runner = {
      instances = {
        mirai = {
          enable = false;
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
          # access_control = {
          #   rules = [
          #     {
          #       domain = "git.darksailor.dev";
          #       policy = "bypass";
          #       resources = [
          #         "^/api([/?].*)?$"
          #       ];
          #     }
          #     {
          #       domain = "git.darksailor.dev";
          #       policy = "one_factor";
          #     }
          #   ];
          # };
          identity_providers = {
            oidc = {
              clients = [
                {
                  client_name = "Gitea: Darksailor";
                  client_id = "gitea";
                  client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_secret".path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = false;
                  # pkce_challenge_method = "S256";
                  redirect_uris = [
                    "https://git.darksailor.dev/user/oauth2/authelia/callback"
                  ];
                  scopes = [
                    "openid"
                    "email"
                    "profile"
                  ];
                  response_types = [ "code" ];
                  grant_types = [ "authorization_code" ];
                  userinfo_signed_response_alg = "none";
                  token_endpoint_auth_method = "client_secret_basic";
                }
              ];
            };
          };
        };
      };
    };
  };
}
