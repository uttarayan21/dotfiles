{unstablePkgs, ...}: {
  services = {
    prowlarr = {
      enable = true;
      package = unstablePkgs.prowlarr;
    };
    caddy = {
      virtualHosts."prowlarr.tsuba.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:9696
      '';
    };
  };
}
