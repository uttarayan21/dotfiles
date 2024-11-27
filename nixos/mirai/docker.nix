{
  config,
  lib,
  pkgs,
  ...
}: {
  # virtualisation = {
  #   docker.enable = true;
  #   podman.enable = true;
  #   oci-containers = {
  #     backend = "podman";
  #     containers.homeassistant = {
  #       volumes = ["home-assistant:/config"];
  #       environment.TZ = "Asia/Kolkata";
  #       image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
  #       extraOptions = [
  #         "--network=ha-net"
  #       ];
  #     };
  #   };
  # };
  # networking.firewall.allowedTCPPorts = [8123];
  # environment.systemPackages = with pkgs; [
  #   docker
  #   podman
  # ];
  # services.caddy = {
  #   enable = true;
  #   virtualHosts."home.darksailor.dev".extraConfig = ''
  #     reverse_proxy localhost:8123
  #   '';
  # };
}
