{config, ...}: {
  sops = {
    secrets."llama/api_key" = {};
    secrets."openai/api_key" = {};
    secrets."openrouter/api_key" = {};
    secrets."gemini/api_key" = {};
  };
  imports = [
    ../../modules/aichat.nix
  ];
  programs.mayichat = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = false;
    settings = {
      save_session = true;
      model = "openai:gpt-4o";
      rag_embedding_model = "ollama:RobinBially/nomic-embed-text-8k";
      clients = [
        {
          type = "openai-compatible";
          name = "mirai";
          api_base = "https://ollama.darksailor.dev/v1";
          api_key_cmd = "cat ${config.sops.secrets."llama/api_key".path}";
          models = [
            # {
            #   name = "RobinBially/nomic-embed-text-8k";
            #   type = "embedding";
            #   default_chunk_size = 8000;
            # }
            {
              name = "gpt-oss-20b";
              type = "chat";
            }
            # {
            #   name = "deepseek-r1:14b";
            #   type = "chat";
            # }
            # {
            #   name = "qwen3:8b";
            #   type = "chat";
            # }
          ];
        }
        {
          type = "openai-compatible";
          name = "ryu";
          api_base = "https://llama.ryu.darksailor.dev/v1";
          models = [
            {
              name = "gpt-oss-20b";
              type = "chat";
            }
            # {
            #   name = "RobinBially/nomic-embed-text-8k";
            #   type = "embedding";
            #   default_chunk_size = 8000;
            # }
            # {
            #   name = "deepseek-r1:7b";
            #   type = "chat";
            # }
            # {
            #   name = "qwen3:30b-a3b";
            #   type = "chat";
            # }
            # {
            #   name = "deepseek-r1:14b";
            #   type = "chat";
            # }
            # {
            #   name = "qwen3:8b";
            #   type = "chat";
            # }
            # {
            #   name = "qwen3:14b";
            #   type = "chat";
            # }
          ];
        }
        {
          type = "gemini";
          name = "gemini";
          api_base = "https://generativelanguage.googleapis.com/v1beta";
          api_key_cmd = "cat ${config.sops.secrets."gemini/api_key".path}";
          # api_key_file = "${config.sops.secrets."gemini/api_key".path}";
          models = [
            {
              name = "gemini-2.5-pro";
              type = "chat";
            }
          ];
        }
        {
          type = "openai-compatible";
          name = "openrouter";
          api_base = "https://openrouter.ai/api/v1";
          api_key_cmd = "cat ${config.sops.secrets."openrouter/api_key".path}";
          models = [
            {
              name = "deepseek/deepseek-r1:free";
              type = "chat";
            }
          ];
        }
        {
          type = "openai-compatible";
          name = "LMStudio";
          api_base = "http://localhost:1234/v1";
          models = [
            {
              name = "openai/gpt-oss-20b";
              type = "chat";
            }
          ];
        }
        {
          type = "openai";
          name = "openai";
          api_base = "https://api.openai.com/v1";
          api_key_cmd = "cat ${config.sops.secrets."openai/api_key".path}";
          models = [
            {
              name = "gpt-3.5-turbo";
            }
            {
              name = "gpt-5-nano";
            }
            {
              name = "o4-mini-high";
            }
          ];
        }
        {
          type = "openai-compatible";
          name = "copilot";
          api_key = "xxx"; # exchange your `ghu_` token at https://api.github.com/copilot_internal/v2/token with Bearer token
          api_base = "https://api.githubcopilot.com";
          patch = {
            # Patch api
            chat_completions = {
              # Api type, possible values: chat_completions, embeddings, and rerank
              ".*" = {
                # The regex to match model names, e.g. '.*' 'gpt-4o' 'gpt-4o|gpt-4-.*'
                headers = {
                  # Patch request headers
                  "Copilot-Integration-Id" = "vscode-chat";
                  "Editor-Version:" = "aichat/0.1.0"; # optional
                };
              };
            };
          };
        }
      ];
    };
    roles = {
      "%git-commit%" =
        /*
        md
        */
        ''
          ---
          model: openai:gpt-4o
          ---
          Your task is to generate a concise and informative commit message based on the provided diff. Use the conventional commit format, which includes a type (feat, fix, chore, docs, style, refactor, perf, test) and an optional scope. The message should be in the imperative mood and should not exceed 72 characters in the subject line. Don't include any additional text or explanations, just the commit message.
        '';
    };
  };
}
