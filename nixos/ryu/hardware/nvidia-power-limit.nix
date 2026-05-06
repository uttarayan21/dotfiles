{
  config,
  pkgs,
  ...
}: let
  # Mitigation for Blackwell GSP CTX SWITCH TIMEOUT (Xid 109).
  # Tracking: NVIDIA/open-gpu-kernel-modules#1080
  # Stock TDP is 575W; capping at 500W reduces frequency of the GSP halt.
  powerLimitWatts = 500;
  smi = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";
in {
  hardware.nvidia.nvidiaPersistenced = true;

  systemd.services.nvidia-power-limit = {
    description = "Cap NVIDIA GPU power limit (Blackwell Xid 109 mitigation)";
    wantedBy = ["multi-user.target"];
    after = ["nvidia-persistenced.service"];
    wants = ["nvidia-persistenced.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${smi} -i 0 -pl ${toString powerLimitWatts}";
    };
  };
}
