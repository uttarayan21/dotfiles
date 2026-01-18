{device, ...}: {
  imports = [
    ./immich-machine-learning.nix
  ];
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };
  users.extraUsers.${device.user}.extraGroups = [
    "docker"
  ];
}
