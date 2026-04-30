{config, ...}: let
  port = 25600;
in {
  systemd.tmpfiles.rules = [
    "Z /media/comics - ${config.services.komga.user} ${config.services.komga.group} - -"
  ];
  services = {
    komga = {
      enable = true;
      settings.server.port = port;
    };
    caddy = {
      virtualHosts."comics.darksailor.dev".extraConfig = ''
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
                resources = ["^/(api|opds|sse)([/?].*)?$"];
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
