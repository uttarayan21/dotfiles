{config, ...}: let
  address = "127.0.0.1:8052";
in {
  networking.domains.subDomains."cache.darksailor.dev" = {};

  sops.secrets."harmonia/sign_key" = {};

  services = {
    harmonia.cache = {
      enable = true;
      signKeyPaths = [config.sops.secrets."harmonia/sign_key".path];
      settings = {
        bind = address;
        priority = 50;
      };
    };
    caddy.virtualHosts."cache.darksailor.dev".extraConfig = ''
      reverse_proxy ${address}
    '';
  };
}
