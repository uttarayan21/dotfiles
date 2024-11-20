{
  config,
  lib,
  pkgs,
  ...
}: {
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/music";
    };
  };
  services.caddy = {
    enable = true;
    virtualHosts."navidrome.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:4533
    '';
  };
}
