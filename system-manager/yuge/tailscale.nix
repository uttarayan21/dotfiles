{pkgs, ...}: {
  systemd.services.tailscaled = {
    description = "Tailscale node agent";
    documentation = ["https://tailscale.com/docs/"];
    wants = ["network-pre.target"];
    after = ["network-pre.target" "NetworkManager.service" "systemd-resolved.service"];
    wantedBy = ["system-manager.target"];

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.tailscale}/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=41641";
      ExecStopPost = "${pkgs.tailscale}/bin/tailscaled --cleanup";
      Restart = "on-failure";
      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = "0755";
      StateDirectory = "tailscale";
      StateDirectoryMode = "0700";
      CacheDirectory = "tailscale";
      CacheDirectoryMode = "0750";
    };
  };
}
