{
  pkgs,
  lib,
  config,
  ...
}: {
  sops = {
    secrets."openai/api_key" = {};
    secrets."llama/api_key".owner = config.services.caddy.user;
    templates = {
      "LLAMA_API_KEY.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
      '';
    };
  };
  services = {
    ollama = {
      enable = true;
      host = "0.0.0.0";
      # loadModels = ["deepseek-r1:7b" "deepseek-r1:14b" "RobinBially/nomic-embed-text-8k" "qwen3:8b" "qwen3:14b"];
      port = 11434;
      # acceleration = "cuda";
      environmentVariables = {
        OLLAMA_ORIGINS = "*";
        OLLAMA_LLM_LIBRARY = "cuda";
        LD_LIBRARY_PATH = "run/opengl-driver/lib";
        HTTP_PROXY = "https://ollama.darksailor.dev";
      };
      package = pkgs.ollama-cuda;
    };
    caddy = {
      virtualHosts."ollama.darksailor.dev".extraConfig = ''
        import cloudflare
        @apikey {
            header Authorization "Bearer {env.LLAMA_API_KEY}"
        }

        handle @apikey {
          header {
            # Set response headers or proxy to a different service if API key is valid
            Access-Control-Allow-Origin *
            -Authorization "Bearer {env.LLAMA_API_KEY}"  # Remove the header after validation
          }
          reverse_proxy localhost:${builtins.toString config.services.ollama.port}
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
