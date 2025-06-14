{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.arion pkgs.docker-client];
  virtualisation.docker.enable = lib.mkForce false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  # users.extraUsers.servius.extraGroups = ["podman"];
  # networking.firewall.allowedTCPPorts = [21063 21064];
  # networking.firewall.allowedUDPPorts = [5353];

  virtualisation.arion = {
    backend = "docker";
    projects = {
      homeassistant.settings.services = {
        homeassistant = {
          service.image = "ghcr.io/home-assistant/home-assistant:stable";
          service.volumes = ["/etc/localtime:/etc/localtime:ro" "/run/dbus:/run/dbus:ro"];
          service.privileged = true;
          service.network_mode = "host";
          service.restart = "unless-stopped";
        };
      };
    };
  };
}
