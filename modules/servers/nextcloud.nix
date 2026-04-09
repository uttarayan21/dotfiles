{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.servers.nextcloud or {};
in {
  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
    }}/nextcloud-extras.nix"
  ];

  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."nextcloud/adminpass".owner = config.users.users.nextcloud.name;
      secrets."authelia/oidc/nextcloud/client_secret".owner = config.users.users.nextcloud.name;
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar bookmarks user_oidc;
      };
      extraAppsEnable = true;
      hostName = cfg.domain;
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
      settings = {};
    };
  };
}
