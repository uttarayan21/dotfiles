{pkgs, ...}: {
  imports = [
    ./guitarix.nix
    ./bambu-studio.nix
    ./guitar.nix
  ];
  home.packages = [
  ];
}
