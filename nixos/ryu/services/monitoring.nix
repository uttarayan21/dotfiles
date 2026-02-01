{pkgs, ...}: let
  # Port configurations
  ports = {
    # System exporters
    node = 9100;
    systemd = 9558;
    process = 9256;
    nvidiagpu = 9835;

    # Infrastructure exporters
    cadvisor = 8080;
    caddy = 2019;
  };
in {
  services = {
    prometheus = {
      exporters = {
        systemd = {
          enable = true;
          port = ports.systemd;
        };
        nvidia-gpu = {
          enable = true;
          port = ports.nvidiagpu;
        };
        node = {
          enable = true;
          enabledCollectors = [
            "systemd"
            "textfile"
            "filesystem"
            "loadavg"
            "meminfo"
            "netdev"
            "stat"
            "time"
            "uname"
            "vmstat"
            "diskstats"
            "cpu"
          ];
          port = ports.node;
        };
        process = {
          enable = true;
          settings.process_names = [
            {
              name = "{{.Comm}}";
              cmdline = [".*"];
            }
          ];
        };
      };
    };
  };

  # Docker cAdvisor for container metrics
  virtualisation.oci-containers.containers.cadvisor = {
    image = "gcr.io/cadvisor/cadvisor:v0.49.1";
    ports = ["${toString ports.cadvisor}:8080"];
    volumes = [
      "/:/rootfs:ro"
      "/var/run:/var/run:ro"
      "/sys:/sys:ro"
      "/var/lib/docker/:/var/lib/docker:ro"
      "/dev/disk/:/dev/disk:ro"
    ];
    extraOptions = [
      "--privileged"
      "--device=/dev/kmsg"
    ];
  };

  # Open firewall ports for Prometheus exporters
  networking.firewall = {
    # Allow from Tailscale network
    interfaces."tailscale0".allowedTCPPorts = [
      ports.node
      ports.systemd
      ports.process
      ports.nvidiagpu
      ports.cadvisor
      ports.caddy
    ];
  };
}
