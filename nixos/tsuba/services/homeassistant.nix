{
  pkgs,
  lib,
  ...
}: {
  services.caddy = {
    virtualHosts."home.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:8123
    '';
  };
}
