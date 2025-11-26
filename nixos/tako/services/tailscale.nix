{masterPkgs, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = "--advertise-exit-node";
    package = masterPkgs.tailscale;
  };
  networking.firewall.trustedInterfaces = [
    "tailscale0"
  ];
}
