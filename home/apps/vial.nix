{
  pkgs,
  device,
  ...
}: {
  home.packages = with pkgs; lib.optionals (device.is "ryu") [vial];
}
