{
  lib,
  device,
  ...
}: {
  xdg = {
    portal = {
      enable = device.is "ryu";
      config = {
        hyprland.default = ["hyprland"];
        common.default = ["*" "hyprland"];
      };
    };

    userDirs.setSessionVariables = lib.mkIf (device.is "ryu" || device.is "tako") true;
  };
}
