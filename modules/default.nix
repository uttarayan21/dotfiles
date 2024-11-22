{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./goread.nix
    ./hyprpaper.nix
    # ./sketchybar.nix
  ];
}
