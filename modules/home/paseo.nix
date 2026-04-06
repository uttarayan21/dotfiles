{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.services.paseo;
  paseoPkg = inputs.paseo.packages.${pkgs.system}.default;
in {
  options = {
    services.paseo = {
      enable = mkEnableOption "paseo daemon";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.paseo = {
      Unit = {
        Description = "Paseo daemon for AI coding agents";
        After = ["network.target"];
      };

      Service = {
        ExecStart = "${paseoPkg}/bin/paseo-server";
        Restart = "on-failure";
        RestartSec = "5";
        Environments = [
          "PASEO_HOME=${config.home.homeDirectory}/.config/paseo"
        ];
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
    home.packages = [paseoPkg];
    home.sessionVariables = {
      PASEO_HOME = "${config.home.homeDirectory}/.config/paseo";
    };
  };
}
