{
  pkgs,
  lib,
  config,
  ...
}: {
  virtualisation.oci-containers = {
    containers = {
      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/var/lib/homeassistant:/config"
          "/etc/localtime:/etc/localtime:ro"
          "/run/dbus:/run/dbus:ro"
        ];
        privileged = true;
        extraOptions = [
          "--network=host"
        ];
        environment = {
          PUID = toString config.users.users.homeassistant.uid;
          PGID = toString config.users.groups.homeassistant.gid;
          TZ = config.time.timeZone;
        };
      };
    };
  };
  users.users.homeassistant = {
    isSystemUser = true;
    home = "/var/lib/homeassistant";
    createHome = true;
    group = "homeassistant";
  };
  users.extraUsers.homeassistant.extraGroups = ["media"];
  users.groups.homeassistant = {};

  services.caddy = {
    virtualHosts."home.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:8123
    '';
  };
}
