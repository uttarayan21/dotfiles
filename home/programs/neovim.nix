{
  pkgs,
  device,
  stablePkgs,
  lib,
  ...
}: {
  programs.nixvim = lib.mkIf (device.is "ryu" || device.is "kuro" || device.is "mirai" || device.is "tako" || device.is "shiro") (
    {
      enable = true;
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
    }
    // (import ./../../neovim {inherit pkgs stablePkgs;})
  );
  stylix.targets.nixvim.enable = lib.mkIf (!(device.is "tsuba")) false;
}
