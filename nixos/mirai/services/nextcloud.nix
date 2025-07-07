{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."nextcloud/adminpass".owner = config.users.users.nextcloud.name;
  };
  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
    }}/nextcloud-extras.nix"
  ];
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar;
      };
      extraAppsEnable = true;
      hostName = "cloud.darksailor.dev";
      config.adminuser = "servius";
      config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      config.dbtype = "sqlite";
      configureRedis = true;
      https = true;
      caching = {
        redis = true;
        apcu = true;
        memcached = true;
      };
      webserver = "caddy";
    };
    # caddy = {
    #   virtualHosts."cloud.darksailor.dev".extraConfig = ''
    #     reverse_proxy localhost:8080
    #   '';
    # };
    # nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    #   {
    #     addr = "127.0.0.1";
    #     port = 8080; # NOT an exposed port
    #   }
    # ];
  };
}
