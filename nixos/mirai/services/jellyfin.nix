{...}: {
  services = {
    jellyfin = {
      enable = false;
      openFirewall = false;
    };
    caddy = {
      virtualHosts."media.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };
}
