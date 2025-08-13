{
  lib,
  config,
  ...
}:
{
  virtualisation.docker.enable = true;
  sops = {
    # secrets."gitea/registration".owner = config.systemd.services.gitea-actions-mirai.serviceConfig.User;
    secrets."gitea/registration" = { };
    templates = {
      "GITEA_REGISTRATION_TOKEN.env".content = ''
        TOKEN=${config.sops.placeholder."gitea/registration"}
      '';
    };
  };
  services = {
    gitea = {
      enable = true;
      lfs.enable = true;
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
          # LFS_START_SERVER = true;
          LFS_ALLOW_PURE_SSH = true;
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
            "ubuntu-latest:docker://node:18-bullseye"
          ];
          tokenFile = "${config.sops.templates."GITEA_REGISTRATION_TOKEN.env".path}";
        };
      };
    };
    caddy = {
      virtualHosts."git.darksailor.dev".extraConfig = ''
        import auth
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
                policy = "bypass";
                resources = [
                  "^/api([/?].*)?$"
                ];
              }
              {
                domain = "git.darksailor.dev";
                policy = "one_factor";
                resources = [
                  "/user/settings"
                ];
              }
            ];
          };
        };
      };
    };
  };
}
