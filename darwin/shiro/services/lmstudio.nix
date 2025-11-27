{...}: {
  services = {
    caddy.virtualHosts."lmstudio.shiro.darksailor.dev" = ''
      import cloudflare
      reverse_proxy localhost:1234
    '';
  };
}
