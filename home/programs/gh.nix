{
  pkgs,
  lib,
  device,
  ...
}: {
  programs = lib.mkIf (!device.isServer) {
    gh.enable = true;
    gh-dash.enable = true;
  };
}
