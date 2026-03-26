{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./nh.nix
    ./fish.nix
  ];
}
