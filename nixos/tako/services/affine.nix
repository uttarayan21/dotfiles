{config, ...}: let
  domain = "notes.darksailor.dev";
in {
  imports = [
    ../../../modules/nixos/affine.nix
  ];

  # SOPS secrets
  sops = {
    secrets = {
      "affine/db_password" = {};
      "authelia/oidc/affine/client_id" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["authelia-darksailor.service"];
      };
      "authelia/oidc/affine/client_secret" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["authelia-darksailor.service"];
      };
    };
    templates."affine.env".content = ''
      AFFINE_DB_PASSWORD=${config.sops.placeholder."affine/db_password"}
      POSTGRES_PASSWORD=${config.sops.placeholder."affine/db_password"}
      AFFINE_SERVER_EXTERNAL_URL=https://${domain}
    '';
  };

  # Enable AFFiNE service
  services.affine = {
    enable = true;
    inherit domain;
    environmentFiles = [
      config.sops.templates."affine.env".path
    ];
  };

  # Caddy reverse proxy with SSO forward auth
  services.caddy.virtualHosts."${domain}".extraConfig = ''
    reverse_proxy localhost:${toString config.services.affine.port}
  '';

  # Authelia access control rules
  services.authelia.instances.darksailor.settings = {
    access_control.rules = [
      {
        inherit domain;
        policy = "bypass";
        resources = [
          "^/api/(sync|awareness)([/?].*)?$"
          "^/socket\\.io([/?].*)?$"
        ];
      }
      {
        inherit domain;
        policy = "one_factor";
      }
    ];
    # OIDC client for AFFiNE
    identity_providers.oidc.clients = [
      {
        client_name = "AFFiNE: Darksailor";
        client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/affine/client_id".path}" }}'';
        client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/affine/client_secret".path}" }}'';
        public = false;
        authorization_policy = "one_factor";
        require_pkce = false;
        redirect_uris = [
          "https://${domain}/oauth/callback"
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

  # Ensure containers start after secrets are available
  systemd.services.docker-affine.after = ["sops-install-secrets.service"];
  systemd.services.docker-affine-migration.after = ["sops-install-secrets.service"];
  systemd.services.docker-affine-postgres.after = ["sops-install-secrets.service"];
}
