{
  pkgs,
  device,
  lib,
  ...
}: let
  activate_linux = pkgs.fetchFromGitHub {
    owner = "Nycta-b424b3c7";
    repo = "eww_activate-linux";
    rev = "master";
    sha256 = "sha256-CHNkRYR4F9JGMrNubHu+XzkwwI3IHzh93nuS7/Plhe4=";
  };
in {
  programs.eww = {
    enable = device.is "ryu";
    enableFishIntegration = true;
    configDir = activate_linux;
  };
}
