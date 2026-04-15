{
  pkgs,
  lib,
  device,
  ...
}: {home.packages = lib.optionals (!device.isServer) [pkgs.ast-grep];}
