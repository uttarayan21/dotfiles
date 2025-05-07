{pkgs, ...}: {
  imports = [../../../modules/macos/ollama.nix];
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    loadModels = [
      "deepseek-r1:7b"
      #   "deepseek-r1:14b"
      #   "RobinBially/nomic-embed-text-8k"
    ];
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };
}
