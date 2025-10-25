{...}: {
  services = {
    prometheus = {
      exporters = {
        systemd = {
          enable = true;
          port = 9558;
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
          ];
          port = 9100;
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

  # Open firewall ports for Prometheus exporters
  networking.firewall = {
    allowedTCPPorts = [
      9100 # node exporter
      9256 # process exporter
      9558 # systemd exporter
      9134 # zfs exporter
      9633 # smartctl exporter
    ];
  };
}
