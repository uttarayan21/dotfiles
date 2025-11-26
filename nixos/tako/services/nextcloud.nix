{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."nextcloud/adminpass".owner = config.users.users.nextcloud.name;
    # secrets."authelia/oidc/nextcloud/client_id".owner = config.users.users.nextcloud.name;
    secrets."authelia/oidc/nextcloud/client_secret".owner = config.users.users.nextcloud.name;
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
      package = pkgs.nextcloud32;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar bookmarks user_oidc;
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
      settings = {};
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

    # authelia.instances.darksailor = {
    #   settings = {
    #     definitions = {
    #       user_attributes = {
    #         is_nextcloud_admin = {
    #           expression = ''"nextcloud-admins" in groups"'';
    #         };
    #       };
    #     };
    #     identity_providers = {
    #       oidc = {
    #         claims_policies = {
    #           custom_claims = {
    #             is_nextcloud_admin = {};
    #           };
    #         };
    #         scopes = {
    #           nextcloud_userinfo = {
    #             claims = ["is_nextcloud_admin"];
    #           };
    #         };
    #         clients = [
    #           {
    #             client_name = "Nextcloud";
    #             client_id = "nextcloud";
    #             client_secret = ''{{ secret "${config.sops.secrets."authelia/oidc/nextcloud/client_secret".path}" }}'';
    #             public = false;
    #             authorization_policy = "one_factor";
    #             require_pkce = true;
    #             pkce_challenge_method = "S256";
    #             claims_policy = "nextcloud_userinfo";
    #             redirect_uris = [
    #               "https://cloud.darksailor.dev/apps/oidc_login/oidc"
    #             ];
    #             scopes = [
    #               "openid"
    #               "profile"
    #               "email"
    #               "groups"
    #               "nextcloud_userinfo"
    #             ];
    #             response_types = ["code"];
    #             grant_types = ["authorization_code"];
    #             # access_token_signed_response_alg = "none";
    #             userinfo_signed_response_alg = "none";
    #             token_endpoint_auth_method = "client_secret_basic";
    #           }
    #         ];
    #       };
    #     };
    #   };
    # };
  };
}
