{config, ...}: let
  address = "127.0.0.1:8052";
in {
  sops = {
    secrets."attic/jwt_secret" = {};
    templates."attic.env".content = ''
      ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."attic/jwt_secret"}
    '';
  };
  services = {
    atticd = {
      enable = true;
      settings.listen = address;
      environmentFile = config.sops.templates."attic.env".path;
    };
    caddy = {
      virtualHosts."cache.darksailor.dev".extraConfig = ''
        reverse_proxy ${address}
      '';
    };
  };
}
