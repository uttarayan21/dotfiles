{unstablePkgs, ...}: {
  services = {
    prowlarr = {
      enable = true;
      package = unstablePkgs.prowlarr;
    };
    caddy = {
      virtualHosts."prowlarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:9696
      '';
    };
  };
}
