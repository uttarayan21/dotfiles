{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    secrets."llama/user".owner = config.services.caddy.user;
    secrets."openai/api_key" = {};
    templates = {
      "LLAMA_API_KEY.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
      '';
      api_key_env.owner = config.services.caddy.user;
      "OPENAI_API_KEY.env".content = ''
        OPENAI_API_KEY="${config.sops.placeholder."openai/api_key"}"
      '';
    };
  };
  services = {
    ollama = {
      enable = true;
      loadModels = ["deepseek-r1:7b" "deepseek-r1:14b" "RobinBially/nomic-embed-text-8k" "Qwen/Qwen3-8B"];
      port = 11434;
      host = "0.0.0.0";
      environmentVariables = {
        OLLAMA_ORIGINS = "*";
      };
    };
    open-webui = {
      enable = true;
      port = 7070;
      environment = {
        SCARF_NO_ANALYTICS = "True";
        DO_NOT_TRACK = "True";
        ANONYMIZED_TELEMETRY = "False";
        WEBUI_AUTH = "False";
        ENABLE_LOGIN_FORM = "False";
        WEBUI_URL = "https://llama.darksailor.dev";
        # OLLAMA_BASE_URL = "https://ollama.darksailor.dev/v1";
        OPENAI_BASE_URL = "https://ollama.darksailor.dev/v1";
      };
      environmentFile = "${config.sops.templates."LLAMA_API_KEY.env".path}";
    };

    caddy = {
      virtualHosts."llama.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:7070
      '';
      virtualHosts."ollama.darksailor.dev".extraConfig = ''
        @apikey {
            header Authorization "Bearer {env.LLAMA_API_KEY}"
        }

        handle @apikey {
          header {
            # Set response headers or proxy to a different service if API key is valid
            Access-Control-Allow-Origin *
            -Authorization "Bearer {env.LLAMA_API_KEY}"  # Remove the header after validation
          }
          reverse_proxy localhost:11434
        }

        respond "Unauthorized" 403
      '';
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."LLAMA_API_KEY.env".path;
    };
  };
}
