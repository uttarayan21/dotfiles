{config, ...}: {
  sops = {
    secrets = {
      "authelia/servers/darksailor/jwtSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/servers/darksailor/storageEncryptionSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/servers/darksailor/sessionSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/users/servius".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      users.owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
    };
  };
  services = {
    authelia = {
      instances.darksailor = {
        enable = true;
        settings = {
          authentication_backend = {
            password_reset.disable = false;
            file = {
              path = "/run/secrets/users";
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
            rules = [
              {
                domain = "darksailor.dev";
                policy = "one_factor";
              }
              # {
              #   domain = "cloud.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "code.darksailor.dev";
              #   policy = "one_factor";
              # }
              # {
              #   domain = "media.darksailor.dev";
              #   policy = "one_factor";
              # }
              {
                domain = "music.darksailor.dev";
                policy = "one_factor";
              }
              {
                domain = "music.darksailor.dev";
                policy = "bypass";
                resources = [
                  "^/rest([/?].*)?$"
                  "^/share([/?].*)?$"
                ];
              }
            ];
          };
          storage = {
            local = {
              path = "/var/lib/authelia-darksailor/authelia.sqlite3";
            };
          };
          theme = "dark";
          notifier.filesystem.filename = "/var/lib/authelia-darksailor/authelia-notifier.log";
          server = {
            address = "127.0.0.1:5555";
            endpoints.authz = {
              forward-auth = {
                implementation = "ForwardAuth";
              };
              auth-request = {
                implementation = "AuthRequest";
              };
            };
          };
          # log = {
          #   file_path = "/tmp/authelia.log";
          # };
        };
        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/servers/darksailor/jwtSecret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/servers/darksailor/storageEncryptionSecret".path;
          sessionSecretFile = config.sops.secrets."authelia/servers/darksailor/sessionSecret".path;
        };
      };
    };
    caddy = {
      virtualHosts."auth.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:5555
      '';
    };
  };
}
