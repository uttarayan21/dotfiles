{...}: {
  services = {
    caddy = {
      enable = true;
      # virtualHosts = {
      #   "home.darksailor.dev".extraConfig = ''
      #     reverse_proxy http://tsuba.lemur-newton.ts.net:8123
      #   '';
      # };
    };
  };
}
