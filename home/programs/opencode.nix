{
  device,
  lib,
  ...
}:
lib.optionalAttrs (device.is "ryu" || device.is "kuro") {
  programs.opencode = {
    enable = true;
    settings.provider = {
      ollama = {
        models = {
          "glm-4.7-flash" = {
            # "_launch" = true;
            name = "glm-4.7-flash";
          };
        };
        name = "Ollama (local)";
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "https://ollama.darksailor.dev/v1";
        };
      };
    };
  };
}
