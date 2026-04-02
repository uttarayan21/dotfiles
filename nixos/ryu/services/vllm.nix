{
  pkgs,
  lib,
  config,
  ...
}: let
  port = 3094;
in {
  sops = {
    secrets."llama/api_key".owner = config.services.caddy.user;
    templates = {
      "LLAMA_API_KEY.env".content = ''
        LLAMA_API_KEY=${config.sops.placeholder."llama/api_key"}
      '';
    };
  };
  systemd.services.vllm = {
    description = "vLLM Inference Server";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      WorkingDirectory = config.users.users.vllm.home;
      ExecStart = "${pkgs.vllm}/bin/vllm serve --host 127.0.0.1 --port ${builtins.toString port} --gpu-memory-utilization .85 zai-org/GLM-4.7-Flash";
      User = config.users.users.vllm.name;
      Environment = [];
    };
  };
  users.users.vllm = {
    isSystemUser = true;
    home = "/var/lib/vllm";
    createHome = true;
    group = config.users.groups.vllm.name;
  };
  users.groups.vllm = {};
  environment.systemPackages = [
    pkgs.vllm
  ];
  services.caddy = {
    virtualHosts."llama.darksailor.dev".extraConfig = ''
      import cloudflare
      @apikey {
          header Authorization "Bearer {env.LLAMA_API_KEY}"
      }

      handle @apikey {
        header {
          # Set response headers or proxy to a different service if API key is valid
          Access-Control-Allow-Origin *
          -Authorization "Bearer {env.LLAMA_API_KEY}"  # Remove the header after validation
        }
        reverse_proxy localhost:${builtins.toString port}
      }

      respond "Unauthorized" 403
    '';
  };
  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."LLAMA_API_KEY.env".path;
    };
  };
}
