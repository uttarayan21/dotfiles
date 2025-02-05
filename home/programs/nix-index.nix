{
  pkgs,
  lib,
  device,
  ...
}: {
  programs = {
    nix-index-database.comma.enable = true;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
