{...}: {
  services = {
    atticd = {
      enable = true;
      listen = "/run/attic/attic.sock";
    };
    caddy = {
      virtualHosts."cache.darksailor.dev".extraConfig = ''
        reverse_proxy /run/attic/attic.sock {
          transport http {
            protocol = "fd"
          }
        }
      '';
    };
  };
}
