{
  lib,
  pkgs,
  device,
  ...
}: {
  home.packages = lib.optionals (device.name == "ryu") [pkgs.moonlight-qt];

  xdg.desktopEntries.moonlight-shiro = lib.mkIf (device.name == "ryu") {
    name = "Shiro Remote";
    comment = "Stream shiro desktop via Sunshine";
    exec = "${pkgs.moonlight-qt}/bin/moonlight stream --resolution 2560x1440 --fps 120 --bitrate 100000 --video-codec hevc --display-mode fullscreen 192.168.0.162 Desktop";
    icon = "moonlight";
    terminal = false;
    type = "Application";
    categories = ["Network" "RemoteAccess"];
  };
}
