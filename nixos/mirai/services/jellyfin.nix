{...}: {
  services = {
    jellyfin = {
      enable = false;
      openFirewall = true;
    };
    caddy = {
      virtualHosts."media.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };
}
