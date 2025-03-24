{pkgs, ...}: {
  imports = [
    ./guitarix.nix
    ./bambu-studio.nix
    ./zed.nix
    ./obs-studio.nix
    ./zathura.nix
  ];
  # home.packages = [];
}
