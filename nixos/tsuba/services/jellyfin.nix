{
  unstablePkgs,
  config,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      jellyfin = {
        image = "jellyfin/jellyfin:latest";
        ports = ["127.0.0.1:8097:8096"];
        volumes = ["/var/lib/jellyfin:/config"];
        user = "jellyfin:jellyfin";
        environment = {
          TZ = config.time.timeZone;
        };
      };
    };
  };
  users.users.jellyfin = {
    isSystemUser = true;
    home = "/var/lib/jellyfin";
    createHome = true;
    group = "jellyfin";
  };
  users.extraUsers.jellyfin.extraGroups = ["media"];
  users.groups.jellyfin = {};

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
