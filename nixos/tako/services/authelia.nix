{config, ...}: let
  port = 5555;
in {
  sops = {
    secrets = let
      user = config.systemd.services.authelia-darksailor.serviceConfig.User;
    in {
      "authelia/servers/darksailor/jwtSecret".owner = user;
      "authelia/servers/darksailor/storageEncryptionSecret".owner = user;
      "authelia/servers/darksailor/sessionSecret".owner = user;
      "authelia/users/servius".owner = user;
      "lldap/users/authelia".owner = user;
      users.owner = user;
      "authelia/oidc/jwks".owner = user;
    };
  };
  services = {
    authelia = {
      instances.darksailor = {
        enable = true;
        settings = {
          authentication_backend = {
            password_reset.disable = false;
            password_change.disable = false;
            ldap = {
              address = "ldap://localhost:389";
              timeout = "5s";
              base_dn = "dc=darksailor,dc=dev";
              user = "cn=authelia,ou=people,dc=darksailor,dc=dev";
              users_filter = "(&({username_attribute}={input})(objectClass=person))";
              groups_filter = "(&(member={dn})(objectClass=groupOfNames))";
              additional_users_dn = "OU=people";
              additional_groups_dn = "OU=groups";
            };
          };
          session = {
            cookies = [
              {
                domain = "darksailor.dev";
                authelia_url = "https://auth.darksailor.dev";
                name = "authelia_session";
              }
            ];
          };
          access_control = {
            default_policy = "one_factor";
            rules = let
              bypass_api = domain: [
                {
                  inherit domain;
                  policy = "bypass";
                  resources = [
                    "^/api([/?].*)?$"
                  ];
                }
                {
                  inherit domain;
                  policy = "one_factor";
                }
              ];
            in
              (bypass_api "sonarr.tsuba.darksailor.dev")
              ++ (bypass_api "radarr.tsuba.darksailor.dev")
              ++ (bypass_api "lidarr.tsuba.darksailor.dev")
              ++ (bypass_api "bazarr.tsuba.darksailor.dev")
              ++ (bypass_api "prowlarr.tsuba.darksailor.dev");
          };
          storage = {
            local = {
              path = "/var/lib/authelia-darksailor/authelia.sqlite3";
            };
          };
          theme = "dark";
          notifier.filesystem.filename = "/var/lib/authelia-darksailor/authelia-notifier.log";
          server = {
            address = "0.0.0.0:${toString port}";
            endpoints.authz = {
              forward-auth = {
                implementation = "ForwardAuth";
              };
              auth-request = {
                implementation = "AuthRequest";
              };
            };
          };
        };
        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/servers/darksailor/jwtSecret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/servers/darksailor/storageEncryptionSecret".path;
          sessionSecretFile = config.sops.secrets."authelia/servers/darksailor/sessionSecret".path;
          oidcHmacSecretFile = config.sops.secrets."authelia/servers/darksailor/sessionSecret".path;
          oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidc/jwks".path;
        };
        environmentVariables = {
          AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.sops.secrets."lldap/users/authelia".path;
        };
      };
    };
    caddy = {
      virtualHosts."auth.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:${toString port} {
            # header_up Host {http.request.header.X-Forwarded-Host}
            # header_up X-Forwarded-Host {http.request.header.X-Forwarded-Host}
            # header_up X-Forwarded-Proto {http.request.header.X-Forwarded-Proto}
        }
      '';
    };
  };
}
