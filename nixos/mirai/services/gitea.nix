{
  lib,
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  sops = {
    # secrets."gitea/registration".owner = config.systemd.services.gitea-actions-mirai.serviceConfig.User;
    secrets."gitea/registration" = {};
    secrets."authelia/oidc/gitea/client_secret" = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
      restartUnits = [
        "gitea.service"
        "authelia-darksailor.service"
      ];
    };
    secrets."authelia/oidc/gitea/client_id" = {
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
      "GITEA_OAUTH_SETUP.env".content = ''
        CLIENT_ID=${config.sops.placeholder."authelia/oidc/gitea/client_id"}
        CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/gitea/client_secret"}
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
          ENABLE_REVERSE_PROXY_AUTHENTICATION = false;
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = false;
          ENABLE_PASSWORD_SIGNIN_FORM = false;
        };
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
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
        openid = {
          ENABLE_OPENID_SIGNIN = false;
          ENABLE_OPENID_SIGNUP = true;
          WHITELISTED_URIS = "auth.darksailor.dev";
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
            "ubuntu-latest:docker://catthehacker/ubuntu:full-latest"
            "ubuntu-22.04:docker://catthehacker/ubuntu:full-22.04"
            "ubuntu-20.04:docker://catthehacker/ubuntu:full-20.04"
            "native:host"
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
                  client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/gitea/client_id".path}" }}'';
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
                  response_types = ["code"];
                  grant_types = ["authorization_code"];
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
  systemd.services.gitea = {
    after = ["sops-install-secrets.service"];
  };

  # systemd.services.gitea-oauth-setup = let
  #   name = "authelia";
  #   gitea_oauth_script = pkgs.writeShellApplication {
  #     name = "gitea_oauth2_script";
  #     runtimeInputs = [config.services.gitea.package];
  #     text = ''
  #       gitea admin auth delete --id "$(gitea admin auth list | grep "${name}" | cut -d "$(printf '\t')" -f1)"
  #       gitea admin auth add-oauth --provider=openidConnect --name=${name} --key="$CLIENT_ID" --secret="$CLIENT_SECRET" --auto-discover-url=https://auth.darksailor.dev/.well-known/openid-configuration --scopes='openid email profile'
  #     '';
  #   };
  # in {
  #   description = "Configure Gitea OAuth with Authelia";
  #   after = ["gitea.service"];
  #   wants = ["gitea.service"];
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = config.services.gitea.user;
  #     Group = config.services.gitea.group;
  #     RemainAfterExit = true;
  #     ExecStart = "${lib.getExe gitea_oauth_script}";
  #     WorkingDirectory = config.services.gitea.stateDir;
  #     EnvironmentFile = config.sops.templates."GITEA_OAUTH_SETUP.env".path;
  #   };
  #   environment = {
  #     GITEA_WORK_DIR = config.services.gitea.stateDir;
  #     GITEA_CUSTOM = config.services.gitea.customDir;
  #   };
  # };
}
