{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./adb.nix
    ./steam.nix
    ./1password.nix
    ./localsend.nix
    ./appimage.nix
    ./obs-studio.nix
  ];
}
