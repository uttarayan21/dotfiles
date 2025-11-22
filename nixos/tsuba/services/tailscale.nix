{masterPkgs, ...}: {
  services = {
    tailscale = {
      enable = true;
      package = masterPkgs.tailscale;
      # useRoutingFeatures = "both";
      # extraUpFlags = ["--advertise-routes=192.168.0.0/24"];
    };
  };
}
