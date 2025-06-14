{pkgs, ...}: {
  services = {
    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "wiz"
        "homekit"
        "homekit_controller"
      ];
      customComponents = [
        pkgs.home-assistant-custom-components.auth-header
      ];
      config = {
        default_config = {};
        homeassistant = {
          external_url = "https://home.darksailor.dev";
          name = "Home Assistant";
          time_zone = "Asia/Kolkata";
        };
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
  networking.firewall.allowedTCPPorts = [
    8888
    5555
    5432
    5000
    7070
    6600
    2019
    22
    21064
    48829
    11434
    3000
    8123
    5432
    443
    22
    80
    55447
    25565
    21064
    40000
  ];
  networking.firewall.allowedUDPPorts = [
    5353
    41641
    68
    5353
    5353
    41641
    47663
    53040
    443
    1900
    1900
    5555
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 21063;
      to = 21070;
    }
  ];
}
