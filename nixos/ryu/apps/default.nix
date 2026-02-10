{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./alvr.nix
    ./easyeffects.nix
    ./vr.nix
    ./helvum.nix
  ];
}
