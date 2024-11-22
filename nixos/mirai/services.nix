{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    factorio-headless
  ];
  sops = {
    # secrets = {
    #   "authelia/darksailor/jwtSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
    #   "authelia/darksailor/storageEncryptionSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
    # };
  };
  services = {
    # authelia = {
    #   instances.darksailor = {
    #     enable = false;
    #     settings = {
    #       # server = {
    #       #   address = "unix:///run/authelia/authelia.sock";
    #       # };
    #       # session.domain = "auth.darksailor.dev";
    #       access_control = {
    #         rules = {
    #         };
    #       };
    #       storage = "local";
    #     };
    #     secrets = {
    #       jwtSecretFile = config.sops.secrets."authelia/darksailor/jwtSecret".path;
    #       storageEncryptionKeyFile = config.sops.secrets."authelia/darksailor/storageEncryptionSecret".path;
    #     };
    #   };
    # };
    tailscale = {
      enable = true;
    };
    factorio = {
      enable = true;
      openFirewall = true;
    };
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
      };
    };
    atuin = {
      enable = true;
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "cloud.darksailor.dev";
      config.adminuser = "servius";
      config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      configureRedis = true;
      https = true;
    };
    llama-cpp = {
      enable = true;
      host = "127.0.0.1";
      port = 3000;
      # model = builtins.fetchurl {
      #   sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
      #   url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
      # };
      model = builtins.fetchurl {
        name = "mistral-7b-claude-chat";
        sha256 = "03458d74d3e6ed650d67e7800492354e5a8a33aaaeabc80c484e28766814085a";
        url = "https://huggingface.co/TheBloke/Mistral-7B-Claude-Chat-GGUF/resolve/main/mistral-7b-claude-chat.Q8_0.gguf?download=true";
      };
    };
    nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
      {
        addr = "127.0.0.1";
        port = 8080; # NOT an exposed port
      }
    ];

    caddy = {
      enable = true;
      virtualHosts."music.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:4533
      '';
      virtualHosts."atuin.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8888
      '';
      virtualHosts."cloud.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8080
      '';
      virtualHosts."llama.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };
  };
}
