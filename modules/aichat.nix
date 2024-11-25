{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.aichat;
  yamlFormat = pkgs.formats.yaml {};
  # configDir =
  #   if pkgs.stdenv.isDarwin then
  #     "${config.home.homeDirectory}Library/Application Support/aichat"
  #   else
  #     "${config.xdg.configHome}/aichat";
in {
  options = {
    programs.aichat = {
      enable = mkEnableOption "aichat";
      package = mkOption {
        type = types.package;
        default = pkgs.aichat;
        defaultText = literalExpression "pkgs.aichat";
        description = "The aichat package to install.";
      };

      settings = lib.mkOption {
        type = yamlFormat.type;
        description = "Options";
      };
    };
  };

  config = {
    home.packages = mkIf cfg.enable [cfg.package];

    xdg.configFile."aichat/config.yaml".source =
      yamlFormat.generate "config.yaml" cfg.settings;
    # xdg.configFile = mkIf cfg.enable {
    #   # "aichat/config.yaml".text = generators.toYAML {} cfg.settings;
    # };
  };
}
