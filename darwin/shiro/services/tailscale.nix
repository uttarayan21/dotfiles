{...}: {
  services = {
    tailscale = {
      enable = true;
      overrideLocalDns = true;
      # useRoutingFeatures = "both";
      # extraUpFlags = ["--advertise-routes=192.168.0.0/24"];
    };
  };
}
