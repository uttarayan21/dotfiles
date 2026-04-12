{
  pkgs,
  lib,
  config,
  ...
}: {
  sops.secrets."homeassistant/puppet-token" = {};
  sops.secrets.esphome = {
    sopsFile = ../../../secrets/esphome.yaml;
    format = "yaml";
    key = "";
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

      esphome = {
        image = "ghcr.io/esphome/esphome:latest";
        extraOptions = [
          "--network=host"
          "--device=/dev/ttyUSB0:/dev/ttyUSB0"
        ];
        volumes = [
          "/var/lib/esphome:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = config.time.timeZone;
        };
      };
    };
  };

  # Generate Puppet config from sops secret
  systemd.services.puppet-config = {
    description = "Generate Puppet addon config";
    wantedBy = ["multi-user.target"];
    before = ["docker-puppet.service"];
    requiredBy = ["docker-puppet.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /var/lib/puppet
      cat > /var/lib/puppet/options.json <<EOF
      {
        "home_assistant_url": "http://localhost:8123",
        "access_token": "$(cat ${config.sops.secrets."homeassistant/puppet-token".path})",
        "keep_browser_open": false
      }
      EOF
    '';
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/esphome 0755 root root -"
    "L+ /var/lib/esphome/secrets.yaml - - - - ${config.sops.secrets.esphome.path}"
    "L+ /var/lib/esphome/esphome.yaml - - - - ${./esphome/esphome.yaml}"
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
