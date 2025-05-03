{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.ollama;
in {
  options = {
    services.ollama = {
      enable = mkEnableOption "Ollama AI model runner";

      package = mkOption {
        type = types.package;
        default = pkgs.ollama;
        defaultText = literalExpression "pkgs.ollama";
        description = "The ollama package to use.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The host address to listen on.";
      };

      port = mkOption {
        type = types.port;
        default = 11434;
        description = "The port to listen on.";
      };

      environmentVariables = mkOption {
        type = types.attrs;
        default = {};
        description = "Environment variables to set for the Ollama service.";
      };

      loadModels = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of models to load on startup.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/ollama";
        description = "Directory to store Ollama data.";
      };
    };
  };

  config = mkIf cfg.enable {
    # users.users.ollama = {
    #   name = "ollama";
    #   uid = 601;
    #   gid = config.users.groups.ollama.gid;
    #   home = cfg.dataDir;
    #   createHome = true;
    #   description = "Ollama service user";
    # };
    #
    # users.groups.ollama = {
    #   name = "ollama";
    #   gid = 602;
    # };

    launchd.daemons.ollama = {
      path = [cfg.package];
      command = "${cfg.package}/bin/ollama serve";
      serviceConfig = {
        Label = "com.ollama.service";
        # ProgramArguments = ["serve"];
        # WorkingDirectory = cfg.dataDir;
        EnvironmentVariables =
          {
            OLLAMA_HOST = cfg.host;
            OLLAMA_PORT = toString cfg.port;
          }
          // cfg.environmentVariables;
        RunAtLoad = true;
        KeepAlive = true;
        # StandardOutPath = "/var/log/ollama.log";
        # StandardErrorPath = "/var/log/ollama.error.log";
        # UserName = "ollama";
        # GroupName = "ollama";
      };
    };

    # system.activationScripts.preActivation.text = mkIf (cfg.loadModels != []) ''
    #   # Load Ollama models
    #   ${concatMapStrings (model: ''
    #       ${cfg.package}/bin/ollama pull ${model}
    #     '')
    #     cfg.loadModels}
    # '';
  };
}
