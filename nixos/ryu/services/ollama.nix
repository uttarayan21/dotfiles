{pkgs, ...}: {
  services = {
    ollama = {
      enable = true;
      host = "127.0.0.1";
      port = 11434;
      package = pkgs.ollama-cuda;
    };
    open-webui = {
      enable = true;
      environment = {
        "OLLAMA_API_BASE_URL" = "http://127.0.0.1:11434/api";
        "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
        WEBUI_AUTH = "False";
        ENABLE_LOGIN_FORM = "False";
      };
    };
  };
}
