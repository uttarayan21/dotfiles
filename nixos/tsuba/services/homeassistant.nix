{
  pkgs,
  lib,
  config,
  ...
}: {
  sops.secrets."homeassistant/puppet-token" = {};
  sops.templates."puppet-options.json".content = builtins.toJSON {
    home_assistant_url = "http://localhost:8123";
    access_token = config.sops.placeholder."homeassistant/puppet-token";
    keep_browser_open = false;
  };

  virtualisation.oci-containers = {
    containers = {
      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:latest";
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

      puppet = {
        image = "ghcr.io/balloob/home-assistant-addons:latest";
        extraOptions = [
          "--network=host"
        ];
        volumes = [
          "/var/lib/puppet/options.json:/data/options.json:ro"
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/puppet 0755 root root -"
    "C+ /var/lib/puppet/options.json 0644 root root - ${config.sops.templates."puppet-options.json".path}"
  ];
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
      import cloudflare
      reverse_proxy localhost:8123
    '';
  };

  # Systemd service to pull latest Home Assistant image
  systemd.services.homeassistant-image-update = {
    description = "Pull latest Home Assistant Docker image";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker pull ghcr.io/home-assistant/home-assistant:latest";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl restart docker-homeassistant.service";
    };
  };

  # Systemd timer to run the update service every 5 days
  systemd.timers.homeassistant-image-update = {
    description = "Timer for Home Assistant image updates";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon *-*-* 02:00:00";
      OnUnitInactiveSec = "5d";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
