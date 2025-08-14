{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./goread.nix
    ./hyprpaper.nix
    # ./aichat.nix
    ./tuifeed.nix
    #./ghostty.nix
    # ./sketchybar.nix
  ];
}
