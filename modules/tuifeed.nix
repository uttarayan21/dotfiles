{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.tuifeed;
  tomlFormat = pkgs.formats.toml {};
in {
  options = {
    programs.tuifeed = {
      enable = mkEnableOption "tuifeed - a terminal RSS/Atom reader";

      config = with types; {
        sources = mkOption {
          type = attrsOf str;
          default = {};
          description = ''
            Sources that will be fetched
          '';
          example = {};
        };

        article_title = mkOption {
          type = attrsOf bool;
          default = {
            "show-author" = true;
            "show-timestamp" = true;
          };
          description = ''
            Options for article titles, such as showing the author and timestamp.
          '';
          example = {};
        };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [pkgs.tuifeed];

    xdg.configFile = mkIf cfg.enable {
      "tuifeed/config.toml".source = tomlFormat.generate "tuifeed-config" {
        sources = cfg.config.sources;
        "article-title" = cfg.config.article_title;
      };
    };
  };
}
