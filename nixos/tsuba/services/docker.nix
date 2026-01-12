{pkgs, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  systemd.services.docker-prune-image = {
    description = "Docker prune unused images";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker image prune -f";
    };
  };
  systemd.timers.docker-prune-image = {
    description = "Timer for docker image prune";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Mon *-*-* 02:00:00";
      OnUnitInactiveSec = "6d";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
