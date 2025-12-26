{...}: {
  services = {
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
        ReverseProxyUserHeader = "Remote-User";
        ReverseProxyWhitelist = "@";
        Address = "/var/run/navidrome/navidrome.sock";
      };
    };
    caddy = {
      virtualHosts."music.darksailor.dev".extraConfig = ''
        import auth
        # reverse_proxy localhost:4533
        reverse_proxy unix//var/run/navidrome/navidrome.sock
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "music.darksailor.dev";
                policy = "bypass";
                resources = [
                  "^/(rest|share)([/?].*)?$"
                ];
              }
              {
                domain = "music.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
}
