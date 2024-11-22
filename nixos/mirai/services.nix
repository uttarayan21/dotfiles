{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    factorio-headless
  ];
  services.factorio = {
    enable = true;
    openFirewall = true;
  };

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/music";
    };
  };
  services.atuin = {
    enable = true;
  };
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.darksailor.dev";
    config.adminuser = "servius";
    config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    configureRedis = true;
    https = true;
  };
  services.llama-cpp = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    model = builtins.fetchurl {
      sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
      url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
    };
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = 8080; # NOT an exposed port
    }
  ];

  services.caddy = {
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
}
