{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.
    yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    theme = builtins.fromTOML (builtins.readFile "${pkgs.catppuccinThemes.yazi}/themes/mocha.toml");
  };
}
