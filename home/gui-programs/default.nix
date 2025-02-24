{
  lib,
  device,
  ...
}: {
  imports = [
    ./cursor.nix
    ./firefox.nix
    ./ghostty.nix
    ./kitty.nix
    ./vscode.nix
    ./wezterm.nix
    ./mpv.nix
  ];
}
