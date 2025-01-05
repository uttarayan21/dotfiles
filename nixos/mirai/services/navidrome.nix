{...}: {
  services = {
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
        ReverseProxyUserHeader = "Remote-User";
        ReverseProxyWhitelist = "127.0.0.1/32";
      };
    };
    caddy = {
      virtualHosts."music.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:4533
      '';
    };
  };
}
