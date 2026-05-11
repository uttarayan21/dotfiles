{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.hass-cli;
  wrapped = pkgs.writeShellScriptBin "hass-cli" ''
    export HASS_SERVER=${escapeShellArg cfg.server}
    export NETRC=/dev/null
    ${optionalString (cfg.tokenFile != null) ''
      HASS_TOKEN="$(cat ${escapeShellArg (toString cfg.tokenFile)})"
      export HASS_TOKEN
    ''}
    exec ${cfg.package}/bin/hass-cli "$@"
  '';
in {
  options.programs.hass-cli = {
    enable = mkEnableOption "home-assistant-cli";
    package = mkPackageOption pkgs "home-assistant-cli" {};
    server = mkOption {
      type = types.str;
      default = "http://localhost:8123";
      example = "https://home.darksailor.dev";
      description = "Home Assistant server URL.";
    };
    tokenFile = mkOption {
      type = types.nullOr (types.either types.path types.str);
      default = null;
      example = literalExpression ''config.sops.secrets."homeassistant/cli-token".path'';
      description = "Path to a file containing a long-lived access token.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [wrapped];
  };
}
