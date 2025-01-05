{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.ghostty;
  # tomlFormat = pkgs.formats.toml {};
  inherit (lib.generatros) toKeyValue mkKeyValueDefault;
in {
  options = {
    programs.ghostty = {
      enable = mkEnableOption "ghostty";
      package = mkPackageOption pkgs "ghostty" {};

      settings = lib.mkOption {
        type = tomlFormat.type;
        description = "Options";
      };
    };
  };

  config = {
    xdg.configFile."ghostty/config".source =
      tomlFormat.generate "config" cfg.settings;
  };
}
