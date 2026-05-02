{config, ...}: let
  port = 4567;
  downloadsDir = "/media/manga";
in {
  networking.domains.subDomains."manga.darksailor.dev" = {};

  sops.secrets."suwayomi/basicAuthPassword".owner = config.services.suwayomi-server.user;
  sops.secrets."suwayomi/basicAuthB64".owner = config.services.caddy.user;
  sops.templates."suwayomi-caddy.env" = {
    content = ''
      SUWAYOMI_BASIC_B64=${config.sops.placeholder."suwayomi/basicAuthB64"}
    '';
    owner = config.services.caddy.user;
  };
  services.caddy.environmentFile = config.sops.templates."suwayomi-caddy.env".path;

  users.users.${config.services.suwayomi-server.user}.extraGroups = [config.services.komga.group];

  systemd.tmpfiles.rules = [
    "d ${downloadsDir} 0775 ${config.services.suwayomi-server.user} ${config.services.komga.group} - -"
  ];

  services = {
    suwayomi-server = {
      enable = true;
      settings.server = {
        ip = "127.0.0.1";
        port = port;
        downloadAsCbz = true;
        downloadsPath = downloadsDir;
        basicAuthEnabled = true;
        basicAuthUsername = "kobo";
        basicAuthPasswordFile = config.sops.secrets."suwayomi/basicAuthPassword".path;
      };
    };
    caddy.virtualHosts."manga.darksailor.dev".extraConfig = ''
      @api_browser {
        path /api /api/*
        header Cookie *authelia_session*
      }
      @api_plugin {
        path /api /api/*
        not header Cookie *authelia_session*
      }
      handle @api_browser {
        import auth
        reverse_proxy localhost:${toString port} {
          header_up Authorization "Basic {$SUWAYOMI_BASIC_B64}"
        }
      }
      handle @api_plugin {
        reverse_proxy localhost:${toString port}
      }
      handle {
        import auth
        reverse_proxy localhost:${toString port} {
          header_up Authorization "Basic {$SUWAYOMI_BASIC_B64}"
        }
      }
    '';
    authelia.instances.darksailor.settings.access_control.rules = [
      {
        domain = "manga.darksailor.dev";
        policy = "bypass";
        resources = ["^/api([/?].*)?$"];
      }
    ];
  };
}
