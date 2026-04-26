{
  inputs,
  pkgs,
  ...
}: let
  website = inputs.servius-website.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  services.caddy.virtualHosts."servius.darksailor.dev".extraConfig = ''
    root * ${website}
    file_server
  '';
}
