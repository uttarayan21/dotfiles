{
  config,
  lib,
  device,
  ...
}:
with lib; let
  cfg = config.servers.navidrome or {};
  socket = "/run/navidrome/navidrome.sock";
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."lastfm/api_key" = {};
      secrets."lastfm/shared_secret" = {};
      templates."lastfm.env".content = ''
        ND_LASTFM_APIKEY=${config.sops.placeholder."lastfm/api_key"}
        ND_LASTFM_SECRET=${config.sops.placeholder."lastfm/shared_secret"}
      '';
    };

    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
        "ExtAuth.TrustedSources" = "@";
        "ExtAuth.UserHeader" = "Remote-User";
        Address = "unix:${socket}";
        BaseUrl = "https://${cfg.domain}";
      };
      environmentFile = config.sops.templates."lastfm.env".path;
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

    users.users.${device.user}.extraGroups = ["navidrome"];
    users.users.caddy.extraGroups = ["navidrome"];
  };
}
