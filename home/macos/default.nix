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
}
