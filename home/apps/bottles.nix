{
  pkgs,
  device,
  ...
}: {
  home.packages = [
    pkgs.bottles
  ];
}
