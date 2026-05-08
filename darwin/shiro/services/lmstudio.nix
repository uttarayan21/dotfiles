{device, ...}: {
  homebrew.casks = ["lm-studio"];
  services = {
    caddy.virtualHosts."lmstudio.shiro.darksailor.dev".extraConfig = ''
      import cloudflare
      reverse_proxy localhost:1234
    '';
  };

  launchd.user.agents.lms-server = {
    serviceConfig = {
      ProgramArguments = [
        "${device.home}/.lmstudio/bin/lms"
        "server"
        "start"
        "--port"
        "1234"
        "--bind"
        "0.0.0.0"
        "--cors"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/lms-server.log";
      StandardErrorPath = "/tmp/lms-server.err.log";
    };
  };
}
