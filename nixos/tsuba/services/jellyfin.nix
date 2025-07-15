{
  unstablePkgs,
  config,
  ...
}: {
  services = {
    jellyseerr = {
      enable = true;
      package = unstablePkgs.jellyseerr;
    };
    caddy = {
      virtualHosts."jellyseerr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.jellyseerr.port}
      '';
      virtualHosts."jellyfin.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:8096
      '';
    };
  };
}
