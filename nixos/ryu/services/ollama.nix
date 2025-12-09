{
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    ollama = {
      enable = true;
      host = "0.0.0.0";
      # loadModels = ["deepseek-r1:7b" "deepseek-r1:14b" "RobinBially/nomic-embed-text-8k" "qwen3:8b" "qwen3:14b"];
      # loadModels = ["deepseek-r1:7b" "deepseek-r1:14b" "RobinBially/nomic-embed-text-8k" "qwen3:8b" "qwen3:14b"];
      port = 11434;
      # acceleration = "cuda";
      environmentVariables = {
        OLLAMA_ORIGINS = "*";
        OLLAMA_LLM_LIBRARY = "cuda";
        LD_LIBRARY_PATH = "run/opengl-driver/lib";
        HTTP_PROXY = "https://ollama.ryu.darksailor.dev";
      };
      package = pkgs.ollama-cuda;
    };
    # open-webui = {
    #   enable = false;
    #   environment = {
    #     OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    #     WEBUI_AUTH = "False";
    #     ENABLE_LOGIN_FORM = "False";
    #   };
    # };
    caddy = {
      # virtualHosts."llama.ryu.darksailor.dev".extraConfig = ''
      #   import cloudflare
      #   forward_auth tako:5555 {
      #       uri /api/authz/forward-auth
      #       copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
      #   }
      #   reverse_proxy localhost:${builtins.toString config.services.open-webui.port}
      # '';
      virtualHosts."ollama.ryu.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:${builtins.toString config.services.ollama.port}
      '';
    };
  };
}
