{
  pkgs,
  lib,
  device,
  ...
}: {
  programs = {
    gh.enable = true;
    gh-dash.enable = true;
  };
}
