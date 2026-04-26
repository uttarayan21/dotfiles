{
  pkgs,
  lib,
  device,
  inputs,
  ...
}: {
  home.packages = lib.optionals (!device.isServer) [
    inputs.nixify.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
