{
  pkgs,
  device,
  stablePkgs,
  lib,
  ...
}:
{
  programs = lib.optionalAttrs (device.is "ryu" || device.is "kuro" || device.is "mirai" || device.is "tako" || device.is "shiro") {
    nixvim =
      {
        enable = true;
        nixpkgs = {
          config = {
            allowUnfree = true;
          };
        };
      }
      // (import ./../../neovim {inherit pkgs stablePkgs;});
  };
}
// lib.optionalAttrs (!(device.is "tsuba")) {
  stylix.targets.nixvim.enable = false;
}
