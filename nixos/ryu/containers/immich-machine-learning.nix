{pkgs, ...}: let
  port = 3003;
in {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      immich-machine-learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:v${pkgs.immich.version}-cuda";
        ports = [
          "0.0.0.0:${toString port}:3003"
        ];
        volumes = [
          "model-cache:/cache"
        ];
      };
    };
  };
  networking.firewall.allowedTCPPorts = [port];
  environment.systemPackages = with pkgs; [
    nvidia-docker
    nvidia-container-toolkit
  ];
  # services.caddy.virtualHosts."ml.ryu.darksailor.dev".extraConfig = ''
  #   reverse_proxy localhost:${toString port}
  # '';
}
