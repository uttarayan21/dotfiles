{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.gitea or {};
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."gitea/registration" = {};
      secrets."authelia/oidc/gitea/client_secret" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["gitea.service" "authelia-darksailor.service"];
      };
      secrets."authelia/oidc/gitea/client_id" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["gitea.service" "authelia-darksailor.service"];
      };
      templates = {
        "GITEA_REGISTRATION_TOKEN.env".content = ''
          TOKEN=${config.sops.placeholder."gitea/registration"}
        '';
        "GITEA_OAUTH_SETUP.env".content = ''
          CLIENT_ID=${config.sops.placeholder."authelia/oidc/gitea/client_id"}
          CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/gitea/client_secret"}
        '';
      };
    };

    services.gitea = {
      enable = true;
      lfs.enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          SHOW_REGISTRATION_BUTTON = false;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = false;
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = false;
          ENABLE_PASSWORD_SIGNIN_FORM = false;
        };
        repository.ENABLE_PUSH_CREATE_USER = true;
        mailer = {
          ENABLED = true;
          PROTOCOL = "sendmail";
        };
        security.REVERSE_PROXY_AUTHENTICATION_USER = "REMOTE-USER";
        server = {
          ROOT_URL = "https://${cfg.domain}";
          DOMAIN = cfg.domain;
          HTTP_PORT = cfg.port;
          LFS_ALLOW_PURE_SSH = true;
        };
        metrics = {
          ENABLED = true;
          TOKEN = "";
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "auto";
          OPENID_CONNECT_SCOPES = "openid profile email";
        };
        openid = {
          ENABLE_OPENID_SIGNIN = false;
          ENABLE_OPENID_SIGNUP = true;
          WHITELISTED_URIS = "auth.darksailor.dev";
        };
      };
    };

    services.gitea-actions-runner.instances.tako = {
      enable = true;
      name = "tako";
      url = "https://${cfg.domain}";
      labels = [
        "ubuntu-latest:docker://catthehacker/ubuntu:full-latest"
        "ubuntu-22.04:docker://catthehacker/ubuntu:full-22.04"
        "ubuntu-20.04:docker://catthehacker/ubuntu:full-20.04"
      ];
      tokenFile = "${config.sops.templates."GITEA_REGISTRATION_TOKEN.env".path}";
    };

    services.authelia.instances.darksailor.settings = {
      identity_providers.oidc.clients = [
        {
          client_name = "Gitea: Darksailor";
          client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_id".path}" }}'';
          client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_secret".path}" }}'';
          public = false;
          authorization_policy = "one_factor";
          require_pkce = false;
          redirect_uris = ["https://${cfg.domain}/user/oauth2/authelia/callback"];
          scopes = ["openid" "email" "profile"];
          response_types = ["code"];
          grant_types = ["authorization_code"];
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_post";
        }
      ];
    };

    systemd.services.gitea.after = ["sops-install-secrets.service"];
  };
}
