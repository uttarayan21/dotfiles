{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.sketchybar;
in {
  options = {
    programs.sketchybar = {
      enable = mkEnableOption "sketchybar - a status bar for macOS";
      # config = with types; {
      # };
    };
  };
  config = {
    home.packages = mkIf cfg.enable [pkgs.sketchybar];
    # home.file = {
    #   ".config/sketchybar/sketchybarrc".text = "";
    # };
  };
}
