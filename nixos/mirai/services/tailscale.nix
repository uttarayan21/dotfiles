{...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = "--advertise-exit-node";
  };
  networking.firewall.trustedInterfaces = [
    "tailscale0"
  ];
}
