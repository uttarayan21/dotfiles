{
  unstablePkgs,
  config,
  lib,
  ...
}: let
  mkCaddy = name: {
    caddy.virtualHosts."${name}.tsuba.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:${builtins.toString config.services.${name}.settings.server.port}
    '';
  };
in {
  services = {
    sonarr = {
      enable = true;
      package = unstablePkgs.sonarr;
      group = "media";
    };
    radarr = {
      enable = true;
      package = unstablePkgs.radarr;
      group = "media";
    };
    lidarr = {
      enable = true;
      package = unstablePkgs.lidarr;
      group = "media";
    };
    caddy.virtualHosts = {
      "sonarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.sonarr.settings.server.port}
      '';
      "radarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.radarr.settings.server.port}
      '';
      "lidarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.lidarr.settings.server.port}
      '';
      "prowlarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy mirai.darksailor.dev:9696
      '';
    };
  };
}
