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
      loadModels = ["deepseek-r1:7b"];
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
        WEBUI_AUTH = "False";
        WEBUI_URL = "https://llama.darksailor.dev";
        ENABLE_LOGIN_FORM = "False";
        OLLAMA_BASE_URL = "https://llama.darksailor.dev/api/ollama";
        # OPENAI_BASE_URLS = "https://api.openai.com/v1;https://llama.darksailor.dev/api/v1";
        OPENAI_BASE_URLS = "https://api.openai.com/v1";
      };
      environmentFile = "${config.sops.templates."OPENAI_API_KEY.env".path}";
    };
    # llama-cpp = let
    #   deepseek_r1 = map (part: "https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-UD-IQ1_M/DeepSeek-R1-UD-IQ1_M-0000${toString part}-of-00004.gguf?download=true") [1 2 3 4];
    # in {
    #   enable = true;
    #   host = "127.0.0.1";
    #   port = 3000;
    #   # model = builtins.fetchurl {
    #   #   name = "qwen_2.5.1_coder_7b_instruct_gguf";
    #   #   sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
    #   #   url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
    #   # };
    #   model = deepseek_r1;
    # };

    caddy = {
      # handle /api/ollama/* {
      #     uri strip_prefix /api/ollama
      #     reverse_proxy localhost:11434
      #
      #     @apikey {
      #         header Authorization "Bearer {env.LLAMA_API_KEY}"
      #     }
      #
      #     handle @apikey {
      #         header {
      #             # Set response headers or proxy to a different service if API key is valid
      #             Access-Control-Allow-Origin *
      #             -Authorization "Bearer {env.LLAMA_API_KEY}"  # Remove the header after validation
      #         }
      #         reverse_proxy localhost:11434
      #     }
      #
      #     handle {
      #         respond "Unauthorized" 403
      #     }
      # }
      virtualHosts."llama.darksailor.dev".extraConfig = ''
        handle /api/v1/* {
          uri strip_prefix /api/v1
          reverse_proxy localhost:3000

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

          handle {
              respond "Unauthorized" 403
          }
        }

        handle {
            forward_auth localhost:5555 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
            reverse_proxy localhost:7070
        }
      '';
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."LLAMA_API_KEY.env".path;
    };
  };
}
