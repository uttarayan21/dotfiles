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
    pkgs.shadps4-qt # uses shadps4-prerelease as backend
    pkgs.bblauncher
  ];

  xdg.desktopEntries.bloodborne = lib.mkIf pkgs.stdenv.isLinux {
    name = "Bloodborne";
    comment = "Bloodborne via BB_Launcher with gamescope";
    exec = "env QT_QPA_PLATFORM=xcb taskset -c 0-15 gamemoderun gamescope -W 2560 -H 1440 -r 120 -f --adaptive-sync --hdr-enabled --force-grab-cursor -- ${pkgs.bblauncher}/bin/BB_Launcher -n";
    icon = "${bloodborne-icon}";
    terminal = false;
    type = "Application";
    categories = ["Game"];
  };
}
