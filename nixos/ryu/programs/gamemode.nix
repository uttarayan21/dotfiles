{
  pkgs,
  device,
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
            ${pkgs.lmstudio}/bin/lms unload
            ${pkgs.libnotify}/bin/notify-send 'GameMode started'
          '';
        in "${out}/bin/gamemode-start";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  users.users.${device.user}.extraGroups = ["gamemode"];
}
