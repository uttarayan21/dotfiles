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
}
