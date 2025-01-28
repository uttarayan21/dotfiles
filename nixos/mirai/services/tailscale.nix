{...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = "--advertise-exit-node";
  };
}
