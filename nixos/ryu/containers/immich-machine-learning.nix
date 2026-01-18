{pkgs, ...}: let
  port = 3003;
in {
  virtualisation.oci-containers = {
    containers = {
      immich-machine-learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:v${pkgs.immich.version}-cuda";
        ports = [
          "127.0.0.1:${toString port}:3003"
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
}
