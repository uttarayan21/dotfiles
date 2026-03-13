{
  pkgs,
  device,
  lib,
  ...
}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = let
          out = pkgs.writeScriptBin "gamemode-start" ''
            ${lib.getExe pkgs.ollama} ps | tail +2 | cut -d' ' -f1 | xargs ${lib.getExe pkgs.ollama} stop
            ${pkgs.libnotify}/bin/notify-send 'GameMode started'
          '';
        in "${out}/bin/gamemode-start";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  users.users.${device.user}.extraGroups = ["gamemode"];
}
