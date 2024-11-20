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
  services.atuin = {
    enable = true;
  };
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.darksailor.dev";
  };
  services.caddy = {
    enable = true;
    virtualHosts."music.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:4533
    '';
    virtualHosts."atuin.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:8888
    '';
    virtualHosts."cloud.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:8080
    '';
  };
}
