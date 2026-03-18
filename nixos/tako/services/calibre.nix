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
        calibreLibrary = "/media/books";
        enableBookConversion = true;
        reverseProxyAuth = {
          enable = true;
          header = "Remote-User";
        };
      };
    };
    caddy = {
      virtualHosts."books.darksailor.dev".extraConfig = ''
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
                domain = "books.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
  systemd.services.calibre-web.path = [pkgs.python311Packages.python-ldap];
  systemd.tmpfiles.settings = {
    calibreBookDirs = {
      "/media/books".d = {
        mode = "775";
        inherit user group;
      };
    };
    calibreWebDirs = {
      "/run/calibre-web".d = {
        mode = "775";
        inherit user group;
      };
    };
  };
  users.users.${device.user} = {
    extraGroups = [group];
  };
  users.users.caddy = {
    extraGroups = [group];
  };
}
