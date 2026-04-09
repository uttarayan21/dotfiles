{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.vaultwarden or {};
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."vaultwarden/admin_token" = {};
      secrets."authelia/oidc/vaultwarden/client_id" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["vaultwarden.service" "authelia-darksailor.service"];
      };
      secrets."authelia/oidc/vaultwarden/client_secret" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["vaultwarden.service" "authelia-darksailor.service"];
      };
      templates."vaultwarden-sso.env".content = ''
        SSO_CLIENT_ID=${config.sops.placeholder."authelia/oidc/vaultwarden/client_id"}
        SSO_CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/vaultwarden/client_secret"}
      '';
    };

    services.vaultwarden = {
      enable = true;
      domain = "https://${cfg.domain}";
      environmentFile = [
        config.sops.secrets."vaultwarden/admin_token".path
        config.sops.templates."vaultwarden-sso.env".path
      ];
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        SIGNUPS_ALLOWED = false;
        SSO_ENABLED = true;
        SSO_ONLY = true;
        SSO_AUTHORITY = "https://auth.darksailor.dev";
        SSO_SCOPES = "profile email offline_access vaultwarden";
        SSO_PKCE = true;
        SSO_ROLES_ENABLED = true;
        SSO_ROLES_DEFAULT_TO_USER = true;
        SSO_ROLES_TOKEN_PATH = "/vaultwarden_roles";
      };
    };

    services.authelia.instances.darksailor.settings = {
      definitions.user_attributes.vaultwarden_roles.expression = ''"vaultwarden_admins" in groups ? ["admin"] : "vaultwarden_users" in groups ? ["user"] : [""]'';
      identity_providers.oidc = {
        claims_policies.vaultwarden = {
          id_token = ["vaultwarden_roles"];
          custom_claims.vaultwarden_roles = {};
        };
        scopes.vaultwarden.claims = ["vaultwarden_roles"];
        clients = [
          {
            client_name = "Vaultwarden";
            client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/vaultwarden/client_id".path}" }}'';
            client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/vaultwarden/client_secret".path}" }}'';
            public = false;
            authorization_policy = "one_factor";
            require_pkce = true;
            pkce_challenge_method = "S256";
            redirect_uris = ["https://${cfg.domain}/identity/connect/oidc-signin"];
            scopes = ["openid" "offline_access" "profile" "email" "vaultwarden"];
            response_types = ["code"];
            grant_types = ["authorization_code" "refresh_token"];
            userinfo_signed_response_alg = "none";
            token_endpoint_auth_method = "client_secret_basic";
          }
        ];
      };
    };
  };
}
