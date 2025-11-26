{config, ...}: {
  sops = {
    secrets.headscale-secret = {
      owner = config.systemd.services.headscale.serviceConfig.User;
      mode = "0440";
      restartUnits = ["headscale.service" "authelia-darksailor.service"];
      key = "authelia/oidc/headscale/client_secret";
    };
    secrets.headscale-authelia = {
      owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      mode = "0440";
      restartUnits = ["headscale.service" "authelia-darksailor.service"];
      key = "authelia/oidc/headscale/client_secret";
    };
  };
  services = {
    headscale = {
      enable = true;
      port = 8095;
      settings = {
        dns = {
          magic_dns = true;
          base_domain = "headscale.darksailor.dev";
          nameservers.global = ["1.1.1.1"];
        };
        oidc = {
          issuer = "https://auth.darksailor.dev";
          client_id = "headscale";
          client_secret_path = "${config.sops.secrets.headscale-secret.path}";
          pkce = {
            enabled = true;
            method = "S256";
          };
        };
      };
    };
    # headplane = {
    #   enable = true;
    #   settings = {
    #     server.port = 42562;
    #   };
    # };
    caddy = {
      virtualHosts."headscale.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:${toString config.services.headplane.settings.server.port}
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          identity_providers = {
            oidc = {
              clients = [
                {
                  client_name = "HeadScale";
                  client_id = "headscale";
                  client_secret = ''{{ secret "${config.sops.secrets.headscale-authelia.path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = true;
                  pkce_challenge_method = "S256";
                  redirect_uris = [
                    "https://headscale.darksailor.dev/oidc/callback"
                  ];
                  scopes = ["openid" "email" "profile" "groups"];
                  response_types = ["code"];
                  grant_types = ["authorization_code"];
                  access_token_signed_response_alg = "none";
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
