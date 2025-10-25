{...}: {
  services = {
    prometheus = {
      exporters = {
        systemd = {
          enable = true;
        };
        nvidia-gpu.enable = true;
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
}
