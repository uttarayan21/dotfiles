{
  pkgs,
  device,
  stablePkgs,
  lib,
  ...
}: {
  stylix.targets.nixvim.enable = false;
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
