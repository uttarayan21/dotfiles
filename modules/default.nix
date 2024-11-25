{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./goread.nix
    ./hyprpaper.nix
    ./aichat.nix
    # ./sketchybar.nix
  ];
}
