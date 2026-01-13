{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.atuin = {
    settings = {
      auto_sync = true;
      sync_frequency = "1m";
      sync_address = "https://atuin.darksailor.dev";
      sync = {
        records = true;
      };
      daemon = {
        enabled = true;
      };
    };
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  systemd.user.services.atuin-daemon = {
    Unit = {
      Description = "Atuin Daemon";
      After = ["network.target"];
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
      Restart = "on-failure";
      RestartSec = "10s";
      # Environment = lib.mkForce "ATUIN_DATA_DIR=${device.home}/.local/share/atuin";
    };
  };
  launchd.agents.atuin-daemon = {
    enable = true;
    config = {
      # A label for the service
      Label = "dev.darksailor.atuin-daemon";
      # The command to run
      ProgramArguments = [
        "${pkgs.atuin}/bin/atuin"
        "daemon"
      ];
      # Run the service when you log in
      RunAtLoad = true;
      # Keep the process alive, or restart if it dies
      KeepAlive = true;
      # Log files
      StandardOutPath = "${device.home}/Library/Logs/atuin-daemon.log";
      StandardErrorPath = "${device.home}/Library/Logs/atuin-daemon.error.log";
    };
  };
}
