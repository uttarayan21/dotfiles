{ pkgs, config, lib, ... }:

with lib;

let cfg = config.programs.goread;
in {
  options = {
    programs.goread = {
      enable = mkEnableOption "goread - a terminal RSS/Atom reader";

      config = with types; {
        urls = mkOption {
          type = attrsOf (listOf attrs);
          default = { };
          description = ''
            Urls that will be fetched ~/.config/goread/urls.yml
          '';
          example = { };
        };

        colorscheme = mkOption {
          type = attrsOf str;
          default = { };
          example = { };
          description = ''
            Colorscheme that will be fetched ~/.config/goread/colorscheme.json
          '';
        };
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [ pkgs.goread ];

    xdg.configFile = mkIf cfg.enable {
      "goread/urls.yml".text = generators.toYAML { } cfg.config.urls;
      # "goread/colorscheme.json".text = lib.generators.toJSON cfg.config.colorscheme;
    };

  };
}
