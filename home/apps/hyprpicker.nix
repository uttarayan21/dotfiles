{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.hyprpicker
  ];

  xdg.desktopEntries.hyprpicker = lib.mkIf pkgs.stdenv.isLinux {
    name = "Hyprpicker";
    comment = "Screen color picker for Hyprland";
    exec = "${lib.getExe pkgs.hyprpicker} --autocopy";
    terminal = false;
    type = "Application";
    categories = ["Utility" "Graphics"];
    noDisplay = false;
  };
}
