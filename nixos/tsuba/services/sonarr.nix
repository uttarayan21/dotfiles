{unstablePkgs, ...}: {
  services = {
    sonarr = {
      enable = true;
      package = unstablePkgs.sonarr;
    };

    caddy = {
      virtualHosts."sonarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:8989
      '';
    };
  };
}
