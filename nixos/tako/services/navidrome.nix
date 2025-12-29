{
  device,
  config,
  ...
}: let
  socket = "/run/navidrome/navidrome.sock";
in {
  sops = {
    secrets."lastfm/api_key" = {};
    secrets."lastfm/shared_secret" = {};
    templates."lastfm.env".content = ''
      ND_LASTFM_APIKEY=${config.sops.placeholder."lastfm/api_key"}
      ND_LASTFM_SECRET=${config.sops.placeholder."lastfm/shared_secret"}
    '';
  };
  services = {
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
        ReverseProxyUserHeader = "Remote-User";
        ReverseProxyWhitelist = "@";
        Address = "unix:${socket}";
        BaseUrl = "https://music.darksailor.dev";
      };
      environmentFile = config.sops.templates."lastfm.env".path;
    };
    caddy = {
      virtualHosts."music.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy unix/${socket}
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
  systemd.services.navidrome.requires = ["systemd-tmpfiles-setup.service"];
  systemd.tmpfiles.settings = {
    navidromeDirs = {
      "/run/navidrome".d = {
        mode = "775";
        user = "navidrome";
        group = "navidrome";
      };
    };
  };
  users.users.${device.user} = {
    extraGroups = ["navidrome"];
  };
  users.users.caddy = {
    extraGroups = ["navidrome"];
  };
}
