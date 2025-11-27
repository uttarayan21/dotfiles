{
  unstablePkgs,
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.services.sonarr = {
    serviceConfig = {
      path = [pkgs.ffmpeg];
    };
  };
  services = let
    settings = {
      auth = {
        authentication_enabled = true;
        authentication_method = "External";
      };
    };
  in {
    sonarr = {
      enable = true;
      package = unstablePkgs.sonarr;
      group = "media";
      inherit settings;
    };
    radarr = {
      enable = true;
      package = unstablePkgs.radarr;
      group = "media";
      inherit settings;
    };
    bazarr = {
      enable = true;
      package = unstablePkgs.bazarr;
      group = "media";
    };
    caddy.virtualHosts = {
      "sonarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        import auth
        reverse_proxy localhost:${builtins.toString config.services.sonarr.settings.server.port}
      '';
      "radarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        import auth
        reverse_proxy localhost:${builtins.toString config.services.radarr.settings.server.port}
      '';
      "lidarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        import auth
        reverse_proxy localhost:${builtins.toString config.services.lidarr.settings.server.port}
      '';
      "bazarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        import auth
        reverse_proxy localhost:${builtins.toString config.services.bazarr.listenPort}
      '';
      "prowlarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        import auth
        reverse_proxy tako.darksailor.dev:9696
      '';
    };
  };
}
