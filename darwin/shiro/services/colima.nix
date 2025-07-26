{
  pkgs,
  device,
  config,
  ...
}: {
  launchd.agents.colima = {
    enable = true;
    config = {
      # A label for the service
      Label = "com.abiosoft.colima";
      # The command to run
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
      ];
      # Run the service when you log in
      RunAtLoad = true;
      # Keep the process alive, or restart if it dies
      KeepAlive = false;
      # Log files
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/colima.error.log";
    };
  };
}
