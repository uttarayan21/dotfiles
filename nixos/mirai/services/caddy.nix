{...}: {
  services = {
    caddy = {
      enable = true;
      extraConfig = ''
        (auth) {
           forward_auth localhost:5555 {
               uri /api/authz/forward-auth?authelia_url=https://auth.darksailor.dev
               copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
           }
        }
      '';
    };
  };
}
