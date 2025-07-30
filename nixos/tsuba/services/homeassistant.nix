{
  pkgs,
  lib,
  ...
}: {
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  users.extraUsers.servius.extraGroups = ["docker"];
  networking.firewall.enable = false;
  services.caddy = {
    virtualHosts."home.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:8123
    '';
  };
}
