{
  lib,
  device,
  ...
}: {
  imports =
    []
    ++ (lib.optionals device.hasGui [
      ./cursor.nix
      ./firefox.nix
      ./ghostty.nix
      ./kitty.nix
      ./vscodium.nix
      ./wezterm.nix
      ./raycast.nix
    ]);
}
