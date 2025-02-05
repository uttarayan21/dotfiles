{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.
    carapace = {
    enable = false;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
}
