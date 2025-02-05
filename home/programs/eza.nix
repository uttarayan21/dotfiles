{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.
    eza = {
    enable = true;
    # enableAliases = true;
    git = true;
    icons = "auto";
  };
}
