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
