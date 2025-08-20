{...}: {
  services = {
    caddy.virtualHosts."lmstudio.shiro.darksailor.dev" = ''
      import hetzner
      reverse_proxy localhost:1234
    '';
  };
}
