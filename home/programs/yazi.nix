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
    theme = builtins.fromTOML (builtins.readFile "${pkgs.catppuccinThemes.yazi}/themes/mocha/catppuccin-mocha-mauve.toml");
    settings = lib.mkIf (device.is "ryu") {
      plugin = {
        prepend_preloaders = [
          {
            name = "/run/user/1000/gvfs";
            run = "noop";
          }
        ];
      };
    };
  };
}
