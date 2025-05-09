{
  pkgs,
  device,
  ...
}: {
  home.packages = [
    pkgs.hyprpicker
  ];
}
