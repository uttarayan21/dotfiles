{device, ...}: {
  launchd.user.agents.caffeinate = {
    command = "/usr/bin/caffeinate -dim";
    serviceConfig = {
      Label = "com.apple.caffeinate";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${device.home}/Library/Logs/caffeinate.log";
      StandardErrorPath = "${device.home}/Library/Logs/caffeinate.error.log";
    };
  };
}
