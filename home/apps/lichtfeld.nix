{
  pkgs,
  inputs,
  device,
  lib,
  ...
}: {
  home.packages = lib.optionals (device.is "ryu") [
    inputs.lichtfeld.packages.${pkgs.system}.lichtfeld
  ];
}

