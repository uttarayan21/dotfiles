# https://wiki.seeedstudio.com/getting_started_with_reterminal_e1002
{config, ...}: {
  sops.secrets.esphome = {
    sopsFile = ../../../secrets/esphome.yaml;
    format = "yaml";
    key = "";
  };

  virtualisation.oci-containers.containers.esphome = {
    image = "ghcr.io/esphome/esphome:latest";
    ports = ["6052:6052"];
    extraOptions = [
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

  systemd.tmpfiles.rules = [
    "d /var/lib/esphome 0755 root root -"
    "C /var/lib/esphome/secrets.yaml 0644 root root - ${config.sops.secrets.esphome.path}"
    "C /var/lib/esphome/reTerminal-e1002.yaml 0644 root root - ${./esphome/reTerminal-e1002.yaml}"
  ];

  services.caddy.virtualHosts."esphome.darksailor.dev".extraConfig = ''
    import cloudflare
    reverse_proxy localhost:6052
  '';
}
