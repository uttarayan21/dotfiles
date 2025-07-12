{
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker.enable = true;
  users.extraUsers.servius.extraGroups = ["docker"];
  services.caddy = {
    virtualHosts."home.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:8123
    '';
  };

  # environment.systemPackages = [pkgs.arion pkgs.docker pkgs.podman];
  # virtualisation.podman.enable = true;
  # virtualisation.podman.dockerSocket.enable = true;
  # # networking.firewall.allowedTCPPorts = [21063 21064];
  # # networking.firewall.allowedUDPPorts = [5353];
  #
  # virtualisation.arion = {
  #   backend = "podman-socket";
  #   projects = {
  #     homeassistant.settings.services = {
  #       homeassistant = {
  #         service.image = "ghcr.io/home-assistant/home-assistant:stable";
  #         service.volumes = ["/etc/localtime:/etc/localtime:ro" "/run/dbus:/run/dbus:ro" "/var/lib/homeassistant:/config"];
  #         service.privileged = true;
  #         service.network_mode = "host";
  #         service.restart = "unless-stopped";
  #       };
  #     };
  #   };
  # };
}
# {
#   virtualisation.podman.enable = true;
#   virtualisation.podman.dockerSocket.enable = true;
#   users.extraUsers.servius.extraGroups = ["podman"];
#   networking.firewall.enable = false;
#   virtualisation.oci-containers = {
#     backend = "podman";
#     containers.homeassistant = {
#       # environment.TZ = "Asia/Kolkata";
#       # Note: The image will not be updated on rebuilds, unless the version label changes
#       image = "ghcr.io/home-assistant/home-assistant:stable";
#       volumes = ["/etc/localtime:/etc/localtime:ro" "/run/dbus:/run/dbus:ro" "/var/lib/homeassistant:/config"];
#       extraOptions = [
#         # Use the host network namespace for all sockets
#         "--network=host"
#         # Pass devices into the container, so Home Assistant can discover and make use of them
#         "--device=/dev/ttyACM0:/dev/ttyACM0"
#       ];
#     };
#   };
# }

