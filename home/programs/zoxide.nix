{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
}
