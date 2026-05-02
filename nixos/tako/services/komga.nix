{
  config,
  device,
  pkgs,
  ...
}: let
  port = 25600;
in {
  networking.domains.subDomains."comics.darksailor.dev" = {};

  systemd.tmpfiles.rules = [
    "Z /media/comics - ${config.services.komga.user} ${config.services.komga.group} - -"
  ];
  systemd.services.komga.environment.KOMGA_KEPUBIFYPATH = "${pkgs.kepubify}/bin/kepubify";
  services = {
    komga = {
      enable = true;
      settings.server.port = port;
    };
    caddy = {
      virtualHosts."comics.darksailor.dev".extraConfig = ''
        log {
          output stdout
        }
        import auth
        reverse_proxy localhost:${toString port}
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "comics.darksailor.dev";
                policy = "bypass";
                resources = ["^/(api|opds|sse|kobo)([/?].*)?$"];
              }
              {
                domain = "comics.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
}
