{
  lib,
  device,
  ...
}: {
  imports =
    []
    ++ (lib.optionals device.hasGui [
      ./raycast.nix
    ]);

  services.kdeconnect.enable = device.hasGui;
  services.kdeconnect.indicator = device.hasGui;
}
