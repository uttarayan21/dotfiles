{config, ...}: {
  services.searx = {
    enable = true;
    # configureUwsgi = true;
    # uwsgiConfig = {
    # socket = "/run/searx/searx.sock";
    # chmod-socket = "660";
    # };
    settings = {
      server = {
        port = "8889";
        secret_key = "foobar";
        base_url = "https://search.darksailor.dev";
      };
    };
  };
  services.caddy.virtualHosts."search.darksailor.dev".extraConfig = ''
    reverse_proxy localhost:8889
  '';
}
