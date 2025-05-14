{...}: {
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = true;
      extraUpFlags = ["--advertise-routes=192.168.0.0/24"];
    };
  };
}
