{
  pkgs,
  lib,
  device,
  config,
  ...
}: {
  sops = {
    secrets."llama/api_key" = {};
    secrets."openai/api_key" = {};
    secrets."openrouter/api_key" = {};
    secrets."gemini/api_key" = {};
  };
  programs.aichat = {
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
          name = "ollama";
          api_base = "https://ollama.darksailor.dev/v1";
          api_key_cmd = "cat ${config.sops.secrets."llama/api_key".path}";
          models = [
            {
              name = "RobinBially/nomic-embed-text-8k";
              type = "embedding";
              default_chunk_size = 8000;
            }
            {
              name = "deepseek-r1:7b";
              type = "chat";
            }
            {
              name = "deepseek-r1:14b";
              type = "chat";
            }
            {
              name = "Qwen/Qwen3-8B";
              type = "chat";
            }
          ];
        }
        {
          type = "gemini";
          name = "gemini";
          api_base = "https://generativelanguage.googleapis.com/v1beta";
          api_key_cmd = "cat ${config.sops.secrets."gemini/api_key".path}";
          models = [
            {
              name = "gemini-2.5-flash-preview-04-17";
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
          type = "openai";
          name = "openai";
          api_base = "https://api.openai.com/v1";
          api_key_cmd = "cat ${config.sops.secrets."openai/api_key".path}";
          models = [
            {
              name = "gpt-3.5-turbo";
            }
            {
              name = "gpt-4o";
            }
          ];
        }
      ];
    };
  };
}
