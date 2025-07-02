{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."nextcloud/adminpass".owner = config.users.users.nextcloud.name;
  };
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      # extraApps = {
      #   inherit (config.services.nextcloud.package.packages.apps) news contacts calendar;
      # };
      # extraAppsEnable = true;
      hostName = "cloud.darksailor.dev";
      config.adminuser = "servius";
      config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      config.dbtype = "sqlite";
      configureRedis = true;
      https = false;
      # datadir = "/media/nextcloud";
      home = "/media/nextcloud";
    };
    caddy = {
      virtualHosts."cloud.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
    nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
      {
        addr = "127.0.0.1";
        port = 8080; # NOT an exposed port
      }
    ];
  };
}
