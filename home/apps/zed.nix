{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.zed-editor
  ];

  # zed-editor = {
  #   enable = true;
  # };
  # xdg.configFile = {
  #   "zed/keymaps.json" = '''';
  #   "zed/settings.json".source = '''';
  # };
}
