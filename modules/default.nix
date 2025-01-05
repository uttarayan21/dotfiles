{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./goread.nix
    ./hyprpaper.nix
    ./aichat.nix
    ./ghostty.nix
    # ./sketchybar.nix
  ];
}
