{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./alvr.nix
    ./easyeffects.nix
    ./vr.nix
    ./crosspipe.nix
    # ./wine.nix
    # ./virt.nix
    ./gparted.nix
    ./nvtop.nix
    # ./qpwgraph.nix
  ];
}
