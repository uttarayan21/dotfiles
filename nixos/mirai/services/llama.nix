{config, ...}: {
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    secrets."llama/user".owner = config.services.caddy.user;
    templates = {
      "LLAMA_API_KEY.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
      '';
      api_key_env.owner = config.services.caddy.user;
    };
  };
  services = {
    ollama = {
      enable = true;
      loadModels = ["RobinBially/nomic-embed-text-8k" "mistral" "hf.co/unsloth/DeepSeek-R1-GGUF:BF16"];
      port = 11434;
      host = "0.0.0.0";
      environmentVariables = {
        OLLAMA_ORIGINS = "*";
      };
    };
    nextjs-ollama-llm-ui = {
      enable = false;
      port = 5096;
      ollamaUrl = "https://llama.darksailor.dev/api/ollama";
    };
    # llama-cpp = {
    #   enable = false;
    #   host = "127.0.0.1";
    #   port = 3000;
    #   model = builtins.fetchurl {
    #     name = "qwen_2.5.1_coder_7b_instruct_gguf";
    #     sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
    #     url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
    #   };
    # };
    # nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    #   {
    #     addr = "127.0.0.1";
    #     port = 8080; # NOT an exposed port
    #   }
    # ];
    caddy = {
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

        handle /api/ollama/* {
            uri strip_prefix /api/ollama
            reverse_proxy localhost:11434

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
            reverse_proxy localhost:5096
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
