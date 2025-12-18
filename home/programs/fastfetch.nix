{
  pkgs,
  lib,
  device,
  config,
  ...
}: let
  nextcloudWallpapers = name: config.home.homeDirectory + "/Nextcloud/Wallpapers/" + name;
in {
  programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = lib.mkIf (device.is "ryu") {
          source = nextcloudWallpapers "hornet.png";
          type = "kitty";
          width = 70;
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          "battery"
          "poweradapter"
          "locale"
          "break"
          "colors"
        ];
      };
    };
    fish.shellAbbrs.ff = "fastfetch";
  };
}
