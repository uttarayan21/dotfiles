{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./guitarix.nix
    ./bambu-studio.nix
    ./zed.nix
    ./obs-studio.nix
    ./zathura.nix
    ./vlc.nix
  ];
  # home.packages = [];
}
