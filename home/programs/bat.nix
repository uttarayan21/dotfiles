{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.
    bat = {
    enable = true;
    config = {theme = "catppuccin";};
    themes = {
      catppuccin = {
        src = "${pkgs.catppuccinThemes.bat}/themes";
        file = "Catppuccin Mocha.tmTheme";
      };
    };
    # extraPackages = with pkgs.bat-extras; [batman batgrep batwatch];
  };
}
