{config, ...}: {
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    secrets."openai/api_key" = {};
    templates = {
      "LLAMA_API_KEY.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
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
        WEBUI_URL = "https://llama.darksailor.dev";
        OLLAMA_API_BASE_URL = "https://ollama.darksailor.dev";
      };
      environmentFile = "${config.sops.templates."LLAMA_API_KEY.env".path}";
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
      EnvironmentFile = config.sops.templates."LLAMA_API_KEY.env".path;
    };
  };
}
