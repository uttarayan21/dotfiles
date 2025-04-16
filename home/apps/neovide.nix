{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.neovide
  ];
}
