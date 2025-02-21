{pkgs, ...}: {
  services = {
    ollama = {
      enable = false;
      host = "127.0.0.1";
      loadModels = ["deepseek-r1:7b" "deepseek-r1:14b"];
      port = 11434;
      acceleration = "cuda";
    };
    open-webui = {
      enable = false;
      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "False";
        ENABLE_LOGIN_FORM = "False";
      };
    };
  };
}
