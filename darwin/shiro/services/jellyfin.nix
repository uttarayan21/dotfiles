{...}: {
  imports = [../../../modules/macos/jellyfin.nix];
  # services = {
  #   jellyfin = {
  #     enable = true;
  #   };
  #   # caddy = {
  #   #   virtualHosts."media.darksailor.dev".extraConfig = ''
  #   #     reverse_proxy localhost:8096
  #   #   '';
  #   # };
  # };
}
