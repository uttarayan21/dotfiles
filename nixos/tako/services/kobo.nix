{
  config,
  inputs,
  pkgs,
  ...
}: let
  port = 8293;
  libraryPath = "/media/books";
in {
  imports = [inputs.kobors.nixosModules.default];

  systemd.tmpfiles.rules = [
    "d ${libraryPath} 0755 ${config.services.kobors.user} ${config.services.kobors.group} - -"
  ];

  services = {
    kobors = {
      enable = true;
      socket = "127.0.0.1:${toString port}";
      externalUrl = "https://books.darksailor.dev";
      calibreLibraryPath = libraryPath;
    };
    caddy = {
      virtualHosts."books.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
