{config, ...}: let
  dataDir = "/var/lib/excalidraw";
  base_domain = "darksailor.dev";
in {
  # SOPS secrets and templates
  sops = {
    secrets = {
      "excalidraw/jwt_secret" = {};
      "authelia/oidc/excalidraw/client_id" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["authelia-darksailor.service"];
      };
      "authelia/oidc/excalidraw/client_secret" = {
        owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
        mode = "0440";
        restartUnits = ["authelia-darksailor.service"];
      };
    };
    templates."excalidraw.env".content = ''
      OIDC_ISSUER_URL=https://auth.${base_domain}
      OIDC_CLIENT_ID=${config.sops.placeholder."authelia/oidc/excalidraw/client_id"}
      OIDC_CLIENT_SECRET=${config.sops.placeholder."authelia/oidc/excalidraw/client_secret"}
      OIDC_REDIRECT_URL=https://draw.${base_domain}/auth/callback
      JWT_SECRET=${config.sops.placeholder."excalidraw/jwt_secret"}
      STORAGE_TYPE=sqlite
      DATA_SOURCE_NAME=excalidraw.db
      LOCAL_STORAGE_PATH=/root/data
    '';
  };

  # Create data directory and initialize SQLite DB
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${dataDir}/data 0755 root root -"
    "f ${dataDir}/excalidraw.db 0644 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # Excalidraw Full backend
      excalidraw = {
        image = "ghcr.io/betterandbetterii/excalidraw-full:latest";
        ports = ["127.0.0.1:3002:3002"];
        environmentFiles = [
          config.sops.templates."excalidraw.env".path
        ];
        volumes = [
          "${dataDir}/data:/root/data"
          "${dataDir}/excalidraw.db:/root/excalidraw.db"
        ];
      };
    };
  };

  # Caddy reverse proxy
  services.caddy.virtualHosts."draw.${base_domain}".extraConfig = ''
    reverse_proxy localhost:3002
  '';

  # Configure Authelia OIDC for Excalidraw
  services.authelia.instances.darksailor.settings = {
    identity_providers = {
      oidc = {
        clients = [
          {
            client_name = "Excalidraw: Darksailor";
            client_id = ''{{ secret "${config.sops.secrets."authelia/oidc/excalidraw/client_id".path}" }}'';
            client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/excalidraw/client_secret".path}" }}'';
            public = false;
            authorization_policy = "one_factor";
            require_pkce = false;
            redirect_uris = [
              "https://draw.${base_domain}/auth/callback"
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
}
