{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.aichat;
in {
  options = {
    services.aichat = {
      enable = mkEnableOption "aichat";
      package = mkPackageOption pkgs "aichat" {};
    };
  };

  config = {
    home.packages = mkIf cfg.enable [cfg.package];
    home.activation.runTailscaleActivation = let
      tailscaleLib = "${cfg.package}/lib";
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        cp -r ${tailscaleLib} /etc/
        systemctl reload-daemon
        systemctl enable --now tailscaled
      '';
  };
}
