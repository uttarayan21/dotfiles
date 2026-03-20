{config, ...}: let
  port = 8222;
in {
  sops = {
    secrets = {
      "vaultwarden/admin_token" = {};
      "authelia/oidc/vaultwarden/client_id" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["vaultwarden.service" "authelia-darksailor.service"];
      };
      "authelia/oidc/vaultwarden/client_secret" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["vaultwarden.service" "authelia-darksailor.service"];
      };
    };
    templates."vaultwarden-sso.env".content = ''
      SSO_CLIENT_ID=${config.sops.placeholder."authelia/oidc/vaultwarden/client_id"}
      SSO_CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/vaultwarden/client_secret"}
    '';
  };
  services = {
    vaultwarden = {
      enable = true;
      domain = "pass.darksailor.dev";
      environmentFile = [
        config.sops.secrets."vaultwarden/admin_token".path
        config.sops.templates."vaultwarden-sso.env".path
      ];
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        SIGNUPS_ALLOWED = false;
        SSO_ENABLED = true;
        SSO_ONLY = true;
        SSO_AUTHORITY = "https://auth.darksailor.dev";
        SSO_SCOPES = "openid offline_access profile email";
        SSO_PKCE = true;
        SSO_ROLES_ENABLED = true;
        SSO_ROLES_DEFAULT_TO_USER = true;
        SSO_ROLES_TOKEN_PATH = "/vaultwarden_roles";
      };
    };
    caddy.virtualHosts."pass.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
    authelia.instances.darksailor.settings = {
      identity_providers.oidc.clients = [
        {
          client_name = "Vaultwarden";
          client_id = "{{ secret \"${config.sops.secrets."authelia/oidc/vaultwarden/client_id".path}\" }}";
          client_secret = "{{ secret \"${config.sops.secrets."authelia/oidc/vaultwarden/client_secret".path}\" }}";
          public = false;
          authorization_policy = "one_factor";
          require_pkce = true;
          pkce_challenge_method = "S256";
          redirect_uris = ["https://pass.darksailor.dev/identity/connect/oidc-signin"];
          scopes = ["openid" "offline_access" "profile" "email"];
          response_types = ["code"];
          grant_types = ["authorization_code" "refresh_token"];
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_basic";
        }
      ];
    };
  };
}
