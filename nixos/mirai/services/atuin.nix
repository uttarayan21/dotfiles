{...}: {
  services = {
    atuin = {
      enable = true;
    };
    caddy = {
      virtualHosts."atuin.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8888
      '';
    };
  };
}
