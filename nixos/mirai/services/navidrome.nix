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
        import auth
        reverse_proxy localhost:4533
      '';
    };
  };
}
