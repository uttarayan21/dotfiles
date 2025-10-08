{
  pkgs,
  unstablePkgs,
  ...
}: {
  services = {
    sonarr = {
      enable = true;
      package = unstablePkgs.sonarr;
    };
    systemd.services.sonarr = {
      serviceConfig = {
        path = [pkgs.ffmpeg];
      };
    };

    caddy = {
      virtualHosts."sonarr.tsuba.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:8989
      '';
    };
  };
}
