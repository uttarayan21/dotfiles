{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    factorio-headless
  ];
  services.factorio = {
    enable = true;
    openFirewall = true;
  };

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
    config.adminuser = "servius";
    config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    configureRedis = true;
    https = true;
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = 8080; # NOT an exposed port
    }
  ];

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
