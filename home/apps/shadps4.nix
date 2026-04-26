{
  pkgs,
  lib,
  ...
}: let
  bloodborne-icon = pkgs.fetchurl {
    url = "https://freepngimg.com/download/bloodborne/37671-3-bloodborne.png";
    sha256 = "sha256-IXM5YIBInHjYCktJGJz44bwT9eVafXPdE9oRu64DenY=";
  };
in {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.shadps4-qt # diegolix29 fork w/ ENABLE_QT_GUI
    pkgs.bblauncher
  ];

  xdg.desktopEntries.bloodborne = lib.mkIf pkgs.stdenv.isLinux {
    name = "Bloodborne";
    comment = "Bloodborne via shadPS4 with gamescope";
    exec = "${pkgs.util-linux}/bin/taskset -c 0-15 ${pkgs.gamemode}/bin/gamemoderun ${pkgs.gamescope}/bin/gamescope -W 2560 -H 1440 -r 90 -f --adaptive-sync --force-grab-cursor -- ${pkgs.shadps4-qt}/bin/shadps4 -g /home/servius/Games/PS4/Bloodborne/CUSA00900/eboot.bin";
    icon = "${bloodborne-icon}";
    terminal = false;
    type = "Application";
    categories = ["Game"];
  };
}
