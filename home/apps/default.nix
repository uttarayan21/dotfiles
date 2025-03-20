{pkgs, ...}: {
  imports = [
    ./guitarix.nix
    ./bambu-studio.nix
    ./zed.nix
    ./obs-studio.nix
  ];
  home.packages = [
  ];
}
