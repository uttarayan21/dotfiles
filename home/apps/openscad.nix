{
  pkgs,
  device,
  ...
}: {
  home.packages = [
    pkgs.openscad
  ];
}
