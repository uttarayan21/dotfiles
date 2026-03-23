{
  pkgs,
  device,
  config,
  ...
}: let
  port = 8134;
  user = config.services.calibre-web.user or "calibre-web";
  group = config.services.calibre-web.group or "calibre-web";
in {
  services = {
    calibre-web = {
      enable = true;
      listen = {
        ip = "127.0.0.1";
        inherit port;
      };
      options = {
        calibreLibrary = "/home/servius/Books";
        enableBookConversion = true;
        # reverseProxyAuth = {
        #   enable = true;
        #   header = "Remote-User";
        # };
      };
    };
    caddy = {
      virtualHosts."books.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };

  users.users.${device.user} = {
    extraGroups = [group];
  };
  users.users.${user} = {
    extraGroups = [device.user];
  };
  users.users.caddy = {
    extraGroups = [group];
  };
}
