{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.jellyfin;
in {
  options.services.jellyfin = {
    enable = mkEnableOption "Jellyfin Media Server";

    package = mkOption {
      type = types.package;
      default = pkgs.jellyfin;
      defaultText = literalExpression "pkgs.jellyfin";
      description = "The package to use for Jellyfin";
    };

    # user = mkOption {
    #   type = types.str;
    #   default = "jellyfin";
    #   description = "User account under which Jellyfin runs.";
    # };
    #
    # group = mkOption {
    #   type = types.str;
    #   default = "jellyfin";
    #   description = "Group under which Jellyfin runs.";
    # };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/jellyfin";
      description = "Directory where Jellyfin stores its data files";
    };
  };

  config = mkIf cfg.enable {
    users.users.jellyfin = {
      name = "jellyfin";
      uid = mkDefault 601;
      gid = mkDefault config.users.groups.jellyfin.gid;
      home = cfg.dataDir;
      createHome = true;
      shell = "/bin/bash";
      description = "Jellyfin runner user account";
    };
    users.groups.jellyfin = {
      name = "jellyfin";
      gid = mkDefault 602;
      description = "Jellyfin runner group";
    };

    environment.systemPackages = [cfg.package];

    launchd.daemons.jellyfin = {
      environment = {
        HOME = cfg.dataDir;
      };
      path = [cfg.package pkgs.coreutils pkgs.darwin.DarwinTools];
      command = "${lib.getExe cfg.package}";
      serviceConfig = {
        # ProcessType = "Background";
        Label = "org.jellyfin.server";
        RunAtLoad = true;
        # KeepAlive = true;
        UserName = "${config.users.users.jellyfin.name}";
        GroupName = "${config.users.groups.jellyfin.name}";
        StandardOutPath = "${cfg.dataDir}/log/jellyfin.log";
        StandardErrorPath = "${cfg.dataDir}/log/jellyfin.error.log";
        WorkingDirectory = cfg.dataDir;
      };
    };
  };
}
