{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.tuifeed;
  tomlFormat = pkgs.formats.toml { };
in
{
  options = {
    programs.tuifeed = {
      enable = mkEnableOption "tuifeed - a terminal RSS/Atom reader";

      config = with types; {
        sources = mkOption {
          type = attrsOf str;
          default = { };
          description = ''
            Urls that will be fetched ~/.config/tuifeed/urls.yml
          '';
          example = { };
        };

        article_title = mkOption {
          type = attrsOf bool;
          default = {
            "show-author" = true;
            "show-timestamp" = true;
          };
          description = ''
            Urls that will be fetched ~/.config/tuifeed/urls.yml
          '';
          example = { };
        };

      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [ pkgs.tuifeed ];

    xdg.configFile = mkIf cfg.enable {
      "tuifeed/config.toml".source = tomlFormat.generate "tuifeed-config" {
        sources = cfg.config.sources;
        "article-title" = cfg.config.article_title;
      };
    };

  };
}
