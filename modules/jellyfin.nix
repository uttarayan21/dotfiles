{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  options.services.jellyfin = {
    enable = mkEnableOption "Jellyfin Media Server";

    package = mkOption {
      type = types.package;
      default = pkgs.jellyfin;
      defaultText = literalExpression "pkgs.jellyfin";
      description = "The package to use for Jellyfin";
    };

    user = mkOption {
      type = types.str;
      default = "jellyfin";
      description = "User account under which Jellyfin runs.";
    };

    group = mkOption {
      type = types.str;
      default = "jellyfin";
      description = "Group under which Jellyfin runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/jellyfin";
      description = "Directory where Jellyfin stores its data files";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.daemons.jellyfin = {
      command = "${lib.getExe cfg.package} --datadir '${cfg.dataDir}'";
      serviceConfig = {
        Label = "org.jellyfin.server";
        RunAtLoad = true;
        KeepAlive = true;
        UserName = cfg.user;
        GroupName = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StandardOutPath = "/var/log/jellyfin.log";
        StandardErrorPath = "/var/log/jellyfin.error.log";
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = {};
    };

    # Create necessary directories and set permissions
    system.activationScripts.preActivation.text = ''
      mkdir -p ${cfg.dataDir}
      chown ${cfg.user}:${cfg.group} ${cfg.dataDir}
    '';
  };
}
