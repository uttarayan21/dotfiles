{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.tailscale;
in {
  options = {
    services.tailscale = {
      enable = mkEnableOption "tailscale";
      package = mkPackageOption pkgs "tailscale" {};
    };
  };

  config = {
    home.packages = mkIf cfg.enable [cfg.package];
    # This doesn't work since we don't have root
    home.activation.copyTailscaledService = mkIf cfg.enable (let
      tailscaleService = "${cfg.package}/lib/systemd/system/tailscaled.service";
    in
      lib.hm.dag.entryAfter ["installPackages"] ''
        verboseEcho Copying the tailscale systemd files to /etc
        run cp ${tailscaleService} /etc/systemd/system/tailscaled.service
      '');
  };
}
