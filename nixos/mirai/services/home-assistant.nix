{
  config,
  pkgs,
  ...
}: {
  services = {
    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "wiz"
      ];
      customComponents = [
        pkgs.home-assistant-custom-components.auth-header
      ];
      config = {
        default_config = {};
        http = {
          server_host = "::1";
          trusted_proxies = ["::1"];
          use_x_forwarded_for = true;
        };
        auth_header = {
          username_header = "Remote-User";
        };
      };
    };
    caddy = {
      virtualHosts."home.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:8123

      '';
    };
  };
}
