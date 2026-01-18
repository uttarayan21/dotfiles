{config, ...}: {
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    secrets."openai/api_key" = {};
    templates = {
      "ollama.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
        OPENAI_API_KEYS=${config.sops.placeholder."openai/api_key"}
      '';
    };
  };
  services = {
    open-webui = {
      enable = true;
      port = 7070;
      environment = {
        SCARF_NO_ANALYTICS = "True";
        DO_NOT_TRACK = "True";
        ANONYMIZED_TELEMETRY = "False";
        WEBUI_AUTH = "False";
        ENABLE_LOGIN_FORM = "False";
        WEBUI_URL = "https://chat.darksailor.dev";
        OLLAMA_BASE_URL = "https://ollama.darksailor.dev";
      };
      environmentFile = "${config.sops.templates."ollama.env".path}";
    };

    caddy = {
      virtualHosts."chat.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:${builtins.toString config.services.open-webui.port}
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "chat.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."ollama.env".path;
    };
  };
}
