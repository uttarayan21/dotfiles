{config, ...}: {
  # sops = {
  #   # secrets."nextcloud/adminpass".owner = config.users.users..name;
  # };
  nixpkgs.config.allowBroken = true;
  services = {
    seafile = {
      enable = true;
      # group = config.services.caddy.group;
      adminEmail = "admin@uttarayan.me";
      initialAdminPassword = "foobar";

      seahubExtraConf =
        /*
        python
        */
        ''
          ENABLE_REMOTE_USER_AUTHENTICATION = True
          # Optional, HTTP header, which is configured in your web server conf file,
          # used for Seafile to get user's unique id, default value is 'HTTP_REMOTE_USER'.
          REMOTE_USER_HEADER = 'HTTP_EMAIL'
          # Optional, when the value of HTTP_REMOTE_USER is not a valid email address，
          # Seafile will build a email-like unique id from the value of 'REMOTE_USER_HEADER'
          # and this domain, e.g. user1@example.com.
          REMOTE_USER_DOMAIN = 'uttarayan.me'
          # Optional, whether to create new user in Seafile system, default value is True.
          # If this setting is disabled, users doesn't preexist in the Seafile DB cannot login.
          # The admin has to first import the users from external systems like LDAP.
          REMOTE_USER_CREATE_UNKNOWN_USER = True
          # Optional, whether to activate new user in Seafile system, default value is True.
          # If this setting is disabled, user will be unable to login by default.
          # the administrator needs to manually activate this user.
          REMOTE_USER_ACTIVATE_USER_AFTER_CREATION = True
        '';
      ccnetSettings = {
        General.SERVICE_URL = "https://cloud.darksailor.dev";
      };
    };
    caddy = {
      virtualHosts."cloud.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy unix//run/seahub/gunicorn.sock
      '';
    };
  };
}
