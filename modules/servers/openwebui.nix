{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.servers.openwebui or {};
in {
  config = mkIf (cfg.enable or false) {
    sops = {
      secrets."llama/api_key".owner = config.services.caddy.user;
      secrets."openai/api_key" = {};
      templates."ollama.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
        OPENAI_API_KEYS=${config.sops.placeholder."openai/api_key"}
      '';
    };

    services.open-webui = {
      enable = true;
      port = cfg.port;
      environment = {
        SCARF_NO_ANALYTICS = "True";
        DO_NOT_TRACK = "True";
        ANONYMIZED_TELEMETRY = "False";
        WEBUI_AUTH = "False";
        ENABLE_LOGIN_FORM = "False";
        WEBUI_URL = "https://${cfg.domain}";
        OLLAMA_BASE_URL = "https://ollama.darksailor.dev";
      };
      environmentFile = "${config.sops.templates."ollama.env".path}";
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."ollama.env".path;
  };
}
