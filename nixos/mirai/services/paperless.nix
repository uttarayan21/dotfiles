{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets."paperless/adminpass".owner = config.users.users.paperless.name;
  };
  services = {
    paperless = {
      enable = true;
      passwordFile = config.sops.secrets."paperless/adminpass".path;
      environmentFile = pkgs.writeText "paperless.env" ''
        PAPERLESS_ENABLE_HTTP_REMOTE_USER=true
        PAPERLESS_URL=https://paperless.darksailor.dev
        PAPERLESS_SECRET_KEY=${config.sops.placeholder."paperless/secret_key"}
      '';
    };
    caddy = {
      virtualHosts."paperless.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:28981
      '';
    };
  };
}
