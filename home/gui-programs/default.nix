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
      ./vscode.nix
      ./wezterm.nix
      ./mpv.nix
    ]);
}
