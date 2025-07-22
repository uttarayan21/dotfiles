{config, ...}: {
  virtualisation.docker.enable = true;
  sops = {
    secrets."gitea/registration".owner = config.systemd.services.gitea-actions-mirai.serviceConfig.User;
    # secrets."gitea/registration" = {};
  };
  services = {
    gitea = {
      enable = true;
      settings = {
        service = {
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = true;
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
        };
      };
    };
    gitea-actions-runner = {
      instances = {
        mirai = {
          name = "mirai";
          enable = true;
          url = "https://git.darksailor.dev";
          labels = [
            "ubuntu-latest:docker://node:18-bullseye"
          ];
          tokenFile = config.sops.secrets."gitea/registration".path;
        };
      };
    };
    caddy = {
      virtualHosts."git.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:3000
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "git.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
}
