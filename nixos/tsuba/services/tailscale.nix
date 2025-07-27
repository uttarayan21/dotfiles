{unstablePkgs, ...}: {
  services = {
    tailscale = {
      enable = true;
      # useRoutingFeatures = "both";
      # extraUpFlags = ["--advertise-routes=192.168.0.0/24"];
      package = unstablePkgs.tailscale;
    };
  };
}
