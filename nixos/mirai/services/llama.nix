{
  config,
  pkgs,
  inputs,
  ...
}:
{
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    secrets."llama/user".owner = config.services.caddy.user;
    secrets."openai/api_key" = { };
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
    llama-cpp = {
      enable = false;
      port = 11435;
      model = pkgs.fetchurl {
        url = "https://huggingface.co/lmstudio-community/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-MXFP4.gguf";
        sha256 = "65d06d31a3977d553cb3af137b5c26b5f1e9297a6aaa29ae7caa98788cde53ab";
      };
      # package = pkgs.ik_llama;
    };
    ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:7b"
        "deepseek-r1:14b"
        "RobinBially/nomic-embed-text-8k"
        "qwen3:8b"
      ];
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
        OPENAI_BASE_URL = "https://ollama.darksailor.dev/v1";
        OLLAMA_API_BASE_URL = "https://ollama.ryu.darksailor.dev";
      };
      environmentFile = "${config.sops.templates."LLAMA_API_KEY.env".path}";
    };

    caddy = {
      virtualHosts."llama.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:${builtins.toString config.services.open-webui.port}
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
          reverse_proxy localhost:${builtins.toString config.services.llama-cpp.port}
        }

        respond "Unauthorized" 403
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "llama.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."LLAMA_API_KEY.env".path;
    };
  };
}
