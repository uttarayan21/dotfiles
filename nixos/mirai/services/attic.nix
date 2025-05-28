{...}: {
  services = {
    atticd = {
      enable = false;
      listen = "/run/attic.sock";
    };
    caddy = {
      virtualHosts."cache.darksailor.dev".extraConfig = ''
        reverse_proxy /run/attic.sock {
          transport http {
            protocol = "fd"
          }
        }
      '';
    };
  };
}
