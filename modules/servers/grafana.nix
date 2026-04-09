{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.grafana or {};
in {
  config = mkIf (cfg.enable or false) {
    sops.secrets."grafana/secret_key" = {
      owner = "grafana";
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = cfg.port;
          domain = cfg.domain;
          root_url = "https://${cfg.domain}";
        };
        auth.disable_login_form = true;
        "auth.basic".enabled = false;
        "auth.anonymous".enabled = false;
        "auth.proxy" = {
          enabled = true;
          header_name = "REMOTE-USER";
          header_property = "username";
          auto_sign_up = true;
        };
        users = {
          allow_sign_up = false;
          auto_assign_org = true;
          auto_assign_org_role = "Admin";
        };
        security = {
          disable_gravatar = true;
          cookie_secure = true;
          secret_key = ''$__file{${config.sops.secrets."grafana/secret_key".path}}'';
        };
        analytics = {
          reporting_enabled = false;
          check_for_updates = false;
        };
      };
    };
  };
}
