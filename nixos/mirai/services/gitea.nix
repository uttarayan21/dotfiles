{...}: {
  services = {
    gitea = {
      enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = false;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
          REVERSE_PROXY_AUTHENTICATION_USER = "REMOTE-USER";
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = true;
        };
      };
    };
    caddy = {
      virtualHosts."git.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
  };
}
