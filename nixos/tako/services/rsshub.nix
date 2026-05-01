{config, ...}: let
  port = 1200;
in {
  networking.domains.subDomains."rsshub.darksailor.dev" = {};

  services = {
    rsshub = {
      enable = true;
      redis = {
        enable = true;
        createLocally = true;
      };
      settings = {
        PORT = port;
        LISTEN_INADDR_ANY = false;
      };
    };
    caddy.virtualHosts."rsshub.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
  };
}
