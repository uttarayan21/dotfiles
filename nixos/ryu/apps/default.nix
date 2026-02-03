{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./alvr.nix
    ./easyeffects.nix
    ./mixid.nix
    ./vr.nix
    ./helvum.nix
  ];
}
