{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.command-runner.homeManagerModules.command-runner
  ];
  services.command-runner = {
    enable = true;
    port = 5599;
    database.path = "${config.home.homeDirectory}/.local/share/command-runner.db";
    commands = let
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
    in
      {
        "display_on" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "on"];
        "display_off" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "off"];
        "display_toggle" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "toggle"];
        "display_status" = [hyprctl "-i" "{instance}" "-j" "monitors"];
        "hyprland_instance" = [hyprctl "-j" "instances"];
      }
      // (builtins.foldl' (acc: elem: acc // elem) {} (lib.map (name: {
        "display_on_${name}" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "on" name];
        "display_off_${name}" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "off" name];
        "display_toggle_${name}" = [hyprctl "-i" "{instance}" "dispatch" "dpms" "toggle" name];
      }) ["HDMI-A-1" "DP-3" "DP-1"]));
  };
}
