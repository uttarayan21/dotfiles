{...}: {
  services = {
    atuin = {
      enable = true;
      openRegistration = false;
    };
    caddy = {
      virtualHosts."atuin.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8888
      '';
    };
  };
}
