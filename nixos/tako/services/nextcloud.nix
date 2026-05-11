{
  config,
  pkgs,
  ...
}: {
  networking.domains.subDomains."cloud.darksailor.dev" = {};

  sops.secrets = let
    autheliaUser = config.systemd.services.authelia-darksailor.serviceConfig.User;
  in {
    "nextcloud/adminpass".owner = config.users.users.nextcloud.name;
    "authelia/oidc/nextcloud/client_id" = {
      owner = autheliaUser;
      mode = "0440";
      restartUnits = ["authelia-darksailor.service" "nextcloud-oidc-register.service"];
    };
    "authelia/oidc/nextcloud/client_secret" = {
      owner = autheliaUser;
      mode = "0440";
      restartUnits = ["authelia-darksailor.service" "nextcloud-oidc-register.service"];
    };
  };
  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
    }}/nextcloud-extras.nix"
  ];
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar bookmarks user_oidc;
      };
      extraAppsEnable = true;
      hostName = "cloud.darksailor.dev";
      config.adminuser = "servius";
      config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      config.dbtype = "sqlite";
      configureRedis = true;
      https = true;
      caching = {
        redis = true;
        apcu = true;
        memcached = true;
      };
      webserver = "caddy";
      settings = {
        allow_local_remote_servers = true;
        hide_login_form = true;
        user_oidc = {
          default_token_endpoint_auth_method = "client_secret_post";
        };
      };
    };
    # caddy = {
    #   virtualHosts."cloud.darksailor.dev".extraConfig = ''
    #     reverse_proxy localhost:8080
    #   '';
    # };
    # nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    #   {
    #     addr = "127.0.0.1";
    #     port = 8080; # NOT an exposed port
    #   }
    # ];

    authelia.instances.darksailor = {
      settings = {
        identity_providers = {
          oidc = {
            clients = [
              {
                client_name = "Nextcloud";
                client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/nextcloud/client_id".path}" }}'';
                client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/nextcloud/client_secret".path}" }}'';
                public = false;
                authorization_policy = "one_factor";
                consent_mode = "pre-configured";
                pre_configured_consent_duration = "1y";
                require_pkce = true;
                pkce_challenge_method = "S256";
                redirect_uris = [
                  "https://cloud.darksailor.dev/apps/user_oidc/code"
                ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                  "groups"
                ];
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

  systemd.services.nextcloud-oidc-register = {
    description = "Register Authelia OIDC provider in Nextcloud user_oidc";
    after = ["phpfpm-nextcloud.service" "authelia-darksailor.service" "nextcloud-setup.service"];
    wants = ["phpfpm-nextcloud.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "nextcloud";
      LoadCredential = [
        "client_id:${config.sops.secrets."authelia/oidc/nextcloud/client_id".path}"
        "client_secret:${config.sops.secrets."authelia/oidc/nextcloud/client_secret".path}"
      ];
    };
    script = ''
      set -euo pipefail
      CID=$(cat "$CREDENTIALS_DIRECTORY/client_id")
      CSEC=$(cat "$CREDENTIALS_DIRECTORY/client_secret")

      occ=${config.services.nextcloud.occ}/bin/nextcloud-occ

      $occ app:enable user_oidc

      $occ user_oidc:provider Authelia \
        --clientid="$CID" \
        --clientsecret="$CSEC" \
        --discoveryuri="https://auth.darksailor.dev/.well-known/openid-configuration" \
        --scope="openid profile email groups" \
        --mapping-uid=preferred_username \
        --mapping-display-name=name \
        --mapping-email=email \
        --mapping-groups=groups \
        --group-provisioning=1 \
        --unique-uid=0 \
        --check-bearer=0

      $occ config:app:set --value=0 user_oidc allow_multiple_user_backends
      $occ config:system:set --value=true --type=boolean user_oidc.use_pkce

      # remove stale keys from earlier deploys
      $occ config:app:delete user_oidc allow_multiple_user_back_ends || true
      $occ config:system:delete user_oidc.disable_account_creation || true
      $occ config:system:delete user_oidc.auto_redirect || true
    '';
  };
}
