{
  pkgs,
  device,
  lib,
  ...
}:
lib.mkIf (device.is "ryu") {
  systemd.user.services.wallpaperengine = {
    Unit = {
      Description = "Linux Wallpaper Engine";
      After = ["hyprland-session.target"];
      Wants = ["hyprland-session.target"];
      PartOf = ["hyprland-session.target"];
    };

    Service = {
      Environment = [
        "XDG_SESSION_TYPE=wayland"
      ];
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine -s --scaling fill --screen-root HDMI-A-1 --bg 2780316434";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStartSec = 30;
    };

    Install = {
      WantedBy = ["hyprland-session.target"];
    };
  };
}
