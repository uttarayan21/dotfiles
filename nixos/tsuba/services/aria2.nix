{
  pkgs,
  config,
  ...
}: {
  sops.secrets."aria2/rpc-secret" = {};

  services.aria2 = {
    enable = true;
    rpcSecretFile = config.sops.secrets."aria2/rpc-secret".path;
    settings = {
      continue = true;
      dir = "/media/downloads";
      enable-rpc = true;
      file-allocation = "none";
      max-concurrent-downloads = 5;
      max-connection-per-server = 16;
      rpc-listen-all = true;
      rpc-listen-port = 6809;
      split = 16;
    };
  };

  services.caddy.virtualHosts."aria2.tsuba.darksailor.dev".extraConfig = ''
    import cloudflare
    root * ${pkgs.ariang}/share/ariang
    file_server
  '';
  services.caddy.virtualHosts."aria2.tsuba.darksailor.dev:6800".extraConfig = ''
    import cloudflare
    reverse_proxy localhost:${toString config.services.aria2.settings.rpc-listen-port}
  '';
}
