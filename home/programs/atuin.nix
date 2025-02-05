{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.atuin = {
    settings = {
      auto_sync = true;
      sync_frequency = "1m";
      sync_address = "https://atuin.darksailor.dev";
    };
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
}
