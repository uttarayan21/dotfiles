{
  pkgs,
  lib,
  device,
  config,
  ...
}: {
  programs.
    aichat = {
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
          name = "llama";
          api_base = "https://llama.darksailor.dev/api/v1";
          api_key_cmd = "cat ${config.sops.secrets."llama/api_key".path}";
          models = [
            {
              name = "qwen_2_5_1";
            }
          ];
        }
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "https://llama.darksailor.dev/api/ollama/v1";
          api_key_cmd = "cat ${config.sops.secrets."llama/api_key".path}";
          models = [
            {
              name = "RobinBially/nomic-embed-text-8k";
              type = "embedding";
              default_chunk_size = 8000;
            }
            {
              name = "mistral";
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
